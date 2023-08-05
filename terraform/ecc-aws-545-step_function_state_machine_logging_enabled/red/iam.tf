data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "iam-545-lambda-red"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "sfn" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["states.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "sfn" {
  name               = "iam-545-sfn-red"
  assume_role_policy = data.aws_iam_policy_document.sfn.json
}

data "aws_iam_policy_document" "sfn_policy" {
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = [
      aws_lambda_function.this.arn,
    ]
  }
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:AssociateKmsKey",
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups",
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "sfn_role_policy" {
  name   = "iam-545-sfn-policy-red"
  role   = aws_iam_role.sfn.id
  policy = data.aws_iam_policy_document.sfn_policy.json
}