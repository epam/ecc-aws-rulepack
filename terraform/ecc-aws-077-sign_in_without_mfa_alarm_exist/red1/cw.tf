resource "aws_cloudwatch_log_group" "this" {
  name = "077_log_group_red1"
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "077_log_stream_red1"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  name           = "077_Console_Sign_in_without_MFA_red1"
  pattern        = "{($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") && ($.userIdentity.type = \"IAMUser\") && ($.responseElements.ConsoleLogin = \"Success\")}"
  log_group_name = aws_cloudwatch_log_group.this.name

  metric_transformation {
    name      = "077_Console_Sign_in_without_MFA_red1"
    namespace = var.namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name                = "077_Console_Sign_in_without_MFA_red1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "077_Console_Sign_in_without_MFA_red1"
  namespace                 = var.namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this.arn]
}
