resource "aws_cloudwatch_log_group" "this" {
  name = "067_log_group_red3"
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "067_log_stream_red3"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_iam_role" "this" {
    name = "067_role_red3"
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
  name = "067_policy_red3"
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
  name           = "067_Unauthorized_API_Calls_red3"
  pattern        = "{(($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")) && (($.sourceIPAddress!=\"delivery.logs.amazonaws.com\") && ($.eventName!=\"HeadBucket\"))}"
  log_group_name = aws_cloudwatch_log_group.this.name

  metric_transformation {
    name      = "067_Unauthorized_API_Calls_red3"
    namespace = var.namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name                = "067_Unauthorized_API_Calls_red3"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "067_Unauthorized_API_Calls_red3"
  namespace                 = var.namespace
  period                    = "120"
  statistic                 = "Minimum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
}