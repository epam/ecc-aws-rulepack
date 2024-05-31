data "aws_iam_policy_document" "this1" {
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DetachNetworkInterface"
      ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "this2" {
  statement {
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey"
      ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "this3" {
  statement {
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecretVersionStage"
      ]
    resources = ["*"]
  }
  statement {
    actions   = ["secretsmanager:GetRandomPassword"]
    resources = ["*"]
  }
}