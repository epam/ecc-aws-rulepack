resource "aws_iam_role" "this" {
  name = "219_iam_role_green"

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

data "aws_iam_policy_document" "this1" {
  statement {
    actions = [
      "lambda:GetFunction",
      "lambda:InvokeAsync",
    "lambda:InvokeFunction"]

    resources = [
      "arn:aws:lambda:::*",
    ]
  }
}

resource "aws_iam_role_policy" "this1" {
  name   = "219_iam_role_policy_green"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this1.json
}

data "aws_iam_policy_document" "this2" {
  statement {
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue",
    "secretsmanager:UpdateSecretVersionStage"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "secretsmanager:resource/AllowRotationLambdaArn"
      values   = ["${aws_lambda_function.this.arn}"]
    }
  }
  statement {
    actions   = ["secretsmanager:GetRandomPassword"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "this2" {
  name   = "219_iam_role_policy2_green"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this2.json
}

data "aws_iam_policy_document" "this3" {
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
    "ec2:DetachNetworkInterface"]
    resources = [aws_secretsmanager_secret.this.arn]
  }
}

resource "aws_iam_role_policy" "this3" {
  name   = "219_iam_role_policy3_green"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this3.json
}

data "aws_iam_policy_document" "this4" {
  statement {
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
    "kms:GenerateDataKey"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "this4" {
  name   = "219_iam_role_policy4_green"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this4.json
}

resource "aws_iam_role_policy_attachment" "this1" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "this2" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}