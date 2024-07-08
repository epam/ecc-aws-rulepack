data "aws_iam_policy_document" "sfn" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["states.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "sfn_policy" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = [
      aws_lambda_function.this.arn,
    ]
  }
  statement {
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

resource "aws_iam_role" "sfn" {
  name               = "${module.naming.resource_prefix.iam_role}-sfn"
  assume_role_policy = data.aws_iam_policy_document.sfn.json
}

resource "aws_iam_role_policy" "sfn_role_policy" {
  name   = "${module.naming.resource_prefix.iam_policy}"
  role   = aws_iam_role.sfn.id
  policy = data.aws_iam_policy_document.sfn_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${module.naming.resource_prefix.iam_role}-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}
