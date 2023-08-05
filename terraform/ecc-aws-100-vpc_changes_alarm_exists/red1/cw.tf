resource "aws_cloudwatch_log_group" "this" {
  name = "100_log_group_red1"
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "100_log_stream_red1"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  name           = "100_VPC_Changes_red1"
  pattern        = "{($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink)}"
  log_group_name = aws_cloudwatch_log_group.this.name


  metric_transformation {
    name      = "100_VPC_Changes_red1"
    namespace = var.namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name                = "100_VPC_Changes_red1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "100_VPC_Changes_red1"
  namespace                 = var.namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this.arn]
}
