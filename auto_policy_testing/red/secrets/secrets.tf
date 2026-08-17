resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

# No rotation — satisfies ecc-aws-218 (rotation disabled)
resource "aws_secretsmanager_secret" "this" {
  name                    = module.naming.resource_prefix.secrets
  recovery_window_in_days = 0
}

# Rotation enabled but lambda fails (setSecret NotImplementedError) —
# RotationEnabled=true and LastRotatedDate absent → ecc-aws-219
resource "aws_secretsmanager_secret" "rotation_failing" {
  name                    = "${module.naming.resource_prefix.secrets}-219"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rotation_failing" {
  secret_id = aws_secretsmanager_secret.rotation_failing.id
  secret_string = jsonencode({
    username = "adminaccount"
    password = random_password.this.result
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_iam_role" "rotation" {
  name                 = "${module.naming.resource_prefix.secrets}-rotation"
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

resource "aws_iam_role_policy" "rotation" {
  name = "${module.naming.resource_prefix.secrets}-rotation"
  role = aws_iam_role.rotation.name
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

resource "aws_iam_role_policy_attachment" "rotation_basic" {
  role       = aws_iam_role.rotation.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "rotation_failing" {
  filename         = "lambda_function.zip"
  function_name    = "${module.naming.resource_prefix.secrets}-219"
  role             = aws_iam_role.rotation.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime          = "python3.12"

  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.${var.region}.amazonaws.com"
    }
  }

  depends_on = [
    aws_iam_role_policy.rotation,
    aws_iam_role_policy_attachment.rotation_basic,
  ]
}

resource "aws_lambda_permission" "rotation_failing" {
  function_name = aws_lambda_function.rotation_failing.function_name
  statement_id  = "AllowExecutionSecretManager"
  action        = "lambda:InvokeFunction"
  principal     = "secretsmanager.amazonaws.com"
}

resource "aws_secretsmanager_secret_rotation" "rotation_failing" {
  secret_id           = aws_secretsmanager_secret.rotation_failing.id
  rotation_lambda_arn = aws_lambda_function.rotation_failing.arn

  rotation_rules {
    automatically_after_days = 7
  }

  depends_on = [aws_lambda_permission.rotation_failing]
}
