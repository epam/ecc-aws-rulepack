resource "aws_cloudwatch_log_group" "this" {
  name = "209_log_group_red1"
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "209_log_stream_red1"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  name           = "209_CMK_key_Disabling_or_Deletion_red1"
  pattern        = "{($.eventSource = kms.amazonaws.com) && (($.eventName=DisableKey)||($.eventName=ScheduleKeyDeletion)) }"
  log_group_name = aws_cloudwatch_log_group.this.name

  metric_transformation {
    name      = "209_CMK_key_Disabling_or_Deletion_red1"
    namespace = var.namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name                = "209_CMK_key_Disabling_or_Deletion_red1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "209_CMK_key_Disabling_or_Deletion_red1"
  namespace                 = var.namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this.arn]
}
