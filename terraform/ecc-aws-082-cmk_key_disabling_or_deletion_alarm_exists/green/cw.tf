resource "aws_cloudwatch_log_group" "this" {
  name = "082_log_group_green"
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "082_log_stream_green"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  name           = "082_CMK_key_Disabling_or_Deletion"
  pattern        = "{ ($.eventSource = kms.amazonaws.com) && (($.eventName=DisableKey)||($.eventName=ScheduleKeyDeletion)) }"
  log_group_name = aws_cloudwatch_log_group.this.name

  metric_transformation {
    name      = "082_CMK_key_Disabling_or_Deletion"
    namespace = var.namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name                = "082_CMK_key_Disabling_or_Deletion"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "082_CMK_key_Disabling_or_Deletion"
  namespace                 = var.namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this.arn]
}
