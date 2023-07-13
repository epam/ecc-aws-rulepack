resource "aws_cloudwatch_log_group" "this" {
  name = "192_log_group_red2"
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "192_log_stream_red2"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_iam_role" "this" {
    name = "192_role_red2"
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
  name = "192_policy_red2"
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

resource "aws_cloudwatch_log_metric_filter" "this" {
  name           = "192_Unauthorized_API_Calls_red2"
  pattern        = "{(($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")) && (($.sourceIPAddress!=\"delivery.logs.amazonaws.com\") && ($.eventName!=\"HeadBucket\"))}"
  log_group_name = aws_cloudwatch_log_group.this.name

  metric_transformation {
    name      = "192_Unauthorized_API_Calls_red2"
    namespace = var.namespace
    value     = "1"
  }
}
