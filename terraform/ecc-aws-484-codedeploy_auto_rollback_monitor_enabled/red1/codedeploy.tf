resource "aws_codedeploy_app" "this" {
  compute_platform = "Lambda"
  name             = "484_codedeploy-app_red1"
}

resource "aws_codedeploy_deployment_config" "this" {
  deployment_config_name = "484_deployment-config_red1"
  compute_platform       = "Lambda"

  traffic_routing_config {
    type = "AllAtOnce"
  }

  depends_on = [aws_codedeploy_app.this]
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = "484_codedeploy_deployment_group_red1"
  service_role_arn       = aws_iam_role.codedeploy_service.arn
  deployment_config_name = aws_codedeploy_deployment_config.this.id

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_STOP_ON_ALARM"]
  }

  alarm_configuration {
    alarms  = ["484_alarm1_red"]
    enabled = false
  }

  depends_on = [aws_codedeploy_app.this, aws_cloudwatch_metric_alarm.this1, aws_iam_role.codedeploy_service]
}

resource "aws_cloudwatch_metric_alarm" "this1" {
  alarm_name          = "484_alarm1_red1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "300"
  unit                = "Milliseconds"
  statistic           = "Maximum"
  threshold           = "10"
  alarm_description   = "This metric monitors Lambda duration."
}