data "aws_caller_identity" "this" {}

resource "aws_accessanalyzer_analyzer" "this" {
  analyzer_name = module.naming.resource_prefix.iam_analyzer

  depends_on = [ aws_s3_bucket.this2, aws_sns_topic.this1 ]
}

resource "aws_iam_account_password_policy" "this" {
  require_lowercase_characters = false
  require_uppercase_characters = false
  require_symbols              = false
  require_numbers              = false
  minimum_password_length      = 8
  password_reuse_prevention    = 3
  max_password_age             = 180
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
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.this.account_id}:log-group:${aws_cloudwatch_log_group.this1.name}:log-stream:*",
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.this.account_id}:log-group:${aws_cloudwatch_log_group.this2.name}:log-stream:*"
        ]
      }
    ]
  }
  POLICY
}

