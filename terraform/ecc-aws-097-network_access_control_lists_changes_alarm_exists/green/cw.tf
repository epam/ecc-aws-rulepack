resource "aws_cloudwatch_log_group" "this" {
  name = "097_log_group_green"
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "097_log_stream_green"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  name           = "097_Network_Access_Control_Lists_Changes_green"
  pattern        = "{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }"
  log_group_name = aws_cloudwatch_log_group.this.name

  metric_transformation {
    name      = "097_Network_Access_Control_Lists_Changes_green"
    namespace = var.namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name                = "097_Network_Access_Control_Lists_Changes_green"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "097_Network_Access_Control_Lists_Changes_green"
  namespace                 = var.namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this.arn]
}
