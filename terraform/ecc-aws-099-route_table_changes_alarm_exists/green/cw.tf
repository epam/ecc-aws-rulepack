resource "aws_cloudwatch_log_group" "this" {
  name = "099_log_group_green"
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "099_log_stream_green"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  name           = "099_Route_Table_Changes_green"
  pattern        = "{($.eventName = CreateRoute) || ($.eventName = CreateRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName = ReplaceRouteTableAssociation) || ($.eventName = DeleteRouteTable) || ($.eventName = DeleteRoute) || ($.eventName = DisassociateRouteTable)}"
  log_group_name = aws_cloudwatch_log_group.this.name

  metric_transformation {
    name      = "099_Route_Table_Changes_green"
    namespace = var.namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name                = "099_Route_Table_Changes_green"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "099_Route_Table_Changes_green"
  namespace                 = var.namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this.arn]
}
