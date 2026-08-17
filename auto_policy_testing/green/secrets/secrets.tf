resource "aws_iam_role" "this" {
  name                 = module.naming.resource_prefix.secrets
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:policy/eo_role_boundary"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "this" {
  name = module.naming.resource_prefix.secrets
  role = aws_iam_role.this.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecretVersionStage",
          "secretsmanager:GetRandomPassword",
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "this" {
  filename         = "lambda_function.zip"
  function_name    = module.naming.resource_prefix.secrets
  role             = aws_iam_role.this.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime          = "python3.12"
  timeout          = 30

  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.${var.region}.amazonaws.com"
      EXCLUDE_CHARACTERS       = "/@\"'\\ "
    }
  }

  depends_on = [
    aws_iam_role_policy.this,
    aws_iam_role_policy_attachment.basic,
  ]

  provisioner "local-exec" {
    command = "sleep 15"
  }
}

resource "aws_lambda_permission" "this" {
  function_name = aws_lambda_function.this.function_name
  statement_id  = "AllowExecutionSecretManager"
  action        = "lambda:InvokeFunction"
  principal     = "secretsmanager.amazonaws.com"
}

resource "random_password" "this" {
  length           = 32
  special          = true
  override_special = "!#$%*()-_=+?"
}

resource "aws_secretsmanager_secret" "this" {
  name                    = module.naming.resource_prefix.secrets
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = random_password.this.result

  lifecycle {
    ignore_changes = [secret_string]
  }
}

# Generic rotation (no RDS): setSecret/testSecret are no-ops so rotation completes
# and LastRotatedDate is set (ecc-aws-219 green).
resource "aws_secretsmanager_secret_rotation" "this" {
  secret_id           = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = aws_lambda_function.this.arn

  rotation_rules {
    automatically_after_days = 7
  }

  depends_on = [
    aws_secretsmanager_secret_version.this,
    aws_lambda_permission.this,
  ]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = replace(<<-EOT
      set -euo pipefail
      SECRET_ID='${aws_secretsmanager_secret.this.id}'
      REGION='${var.region}'
      for i in $(seq 1 40); do
        LAST=$(aws secretsmanager describe-secret --secret-id "$SECRET_ID" --region "$REGION" \
          --query 'LastRotatedDate' --output text 2>/dev/null | tr -d '\r\n' || true)
        echo "LastRotatedDate=$LAST (attempt $i)"
        case "$LAST" in
          None|null|"") ;;
          *)
            # Touch the secret so LastAccessedDate is set (ecc-aws-220 green)
            aws secretsmanager get-secret-value --secret-id "$SECRET_ID" --region "$REGION" >/dev/null
            exit 0
            ;;
        esac
        sleep 10
      done
      echo "Timed out waiting for successful secret rotation" >&2
      aws secretsmanager describe-secret --secret-id "$SECRET_ID" --region "$REGION" >&2 || true
      exit 1
    EOT
    , "\r", "")
  }
}
