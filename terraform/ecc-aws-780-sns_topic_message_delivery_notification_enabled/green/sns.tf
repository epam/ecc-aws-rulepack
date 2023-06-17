resource "aws_sns_topic" "this" {
  name                           = "sns-780-green"
  http_success_feedback_role_arn = aws_iam_role.success.arn
  http_failure_feedback_role_arn = aws_iam_role.failure.arn
}

resource "aws_iam_role" "success" {
  name                = "780-success-role-green"
  assume_role_policy  = data.aws_iam_policy_document.this.json
  managed_policy_arns = [aws_iam_policy.this.arn]
}

resource "aws_iam_role" "failure" {
  name                = "780-failure-role-green"
  assume_role_policy  = data.aws_iam_policy_document.this.json
  managed_policy_arns = [aws_iam_policy.this.arn]
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "this" {
  name = "780-policy-green"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                    "logs:PutMetricFilter",
                    "logs:PutRetentionPolicy"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
