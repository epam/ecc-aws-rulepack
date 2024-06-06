data "aws_caller_identity" "this" {}

resource "aws_iam_account_password_policy" "this" {
  require_lowercase_characters = true
  require_uppercase_characters = true
  require_symbols              = true
  require_numbers              = true
  minimum_password_length      = 14
  password_reuse_prevention    = 24
  max_password_age             = 90
}

resource "aws_accessanalyzer_analyzer" "this" {
  analyzer_name = module.naming.resource_prefix.iam_analyzer
}

resource "aws_iam_role" "this" {
  name               = module.naming.resource_prefix.iam_role
  assume_role_policy = <<-POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
    POLICY
}

resource "aws_iam_role_policy" "this" {
  name   = module.naming.resource_prefix.iam_policy
  role   = aws_iam_role.this.id
  policy = <<-POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": [
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.this.account_id}:log-group:${aws_cloudwatch_log_group.this.name}:log-stream:*",
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.this.account_id}:log-group:${aws_cloudwatch_log_group.this2.name}:log-stream:*"
        ]
      }
    ]
  }
  POLICY
}