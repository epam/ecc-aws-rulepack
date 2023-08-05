resource "aws_cloudwatch_log_group" "this" {
  name = "067_log_group_red"
}
resource "aws_cloudwatch_log_metric_filter" "this" {
  name           = "067_Unauthorized_API_Calls_red"
  pattern        = "{(($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")) && (($.sourceIPAddress!=\"delivery.logs.amazonaws.com\") && ($.eventName!=\"HeadBucket\"))}"
  log_group_name = aws_cloudwatch_log_group.this.name

  metric_transformation {
    name      = "067_Unauthorized_API_Calls_Count_red"
    namespace = "API_Calls"
    value     = "1"
  }
}
resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name                = "067_Unauthorized_API_Calls_red"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "067_Unauthorized_API_Calls_Count_red"
  namespace                 = "API_Calls"
  period                    = "120"
  statistic                 = "Minimum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
}