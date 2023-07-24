resource "aws_cloudwatch_log_group" "this" {
  name = "192_log_group_green"
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  name           = "192_Unauthorized_API_Calls_green"
  pattern        = "{(($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")) && (($.sourceIPAddress!=\"delivery.logs.amazonaws.com\") && ($.eventName!=\"HeadBucket\"))}"

  log_group_name = aws_cloudwatch_log_group.this.name

  metric_transformation {
    name      = "192_Unauthorized_API_Calls_green"
    namespace = var.namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name                = "192_Unauthorized_API_Calls_green"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "192_Unauthorized_API_Calls_green"
  namespace                 = var.namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this.arn]
}