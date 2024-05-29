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

data "aws_iam_policy_document" "this4" {
  statement {
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
    "kms:GenerateDataKey"]
    resources = ["*"]
  }
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