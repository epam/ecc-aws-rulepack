resource "aws_cloudwatch_log_group" "this" {
  name = "067_log_group_red1"
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "067_log_stream_red1"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_iam_role" "this" {
    name = "067_role_red1"
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
  name = "067_policy_red1"
  role = aws_iam_role.this.id
  policy = <<-POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream"
        ],
        "Resource": [
          "arn:aws:logs:${var.default-region}:${data.aws_caller_identity.this.account_id}:log-group:${aws_cloudwatch_log_group.this.name}:log-stream:*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "logs:PutLogEvents"
        ],
        "Resource": [
          "arn:aws:logs:${var.default-region}:${data.aws_caller_identity.this.account_id}:log-group:${aws_cloudwatch_log_group.this.name}:log-stream:*"
        ]
      }
    ]
  }
  POLICY
}