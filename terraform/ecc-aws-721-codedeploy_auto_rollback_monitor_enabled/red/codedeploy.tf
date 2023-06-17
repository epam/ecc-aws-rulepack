resource "aws_codedeploy_app" "this" {
  compute_platform = "Lambda"
  name             = "721_codedeploy-app_red"
}

resource "aws_codedeploy_deployment_config" "this" {
  deployment_config_name = "721_deployment-config_red"
  compute_platform       = "Lambda"

  traffic_routing_config {
    type = "AllAtOnce"
  }

  depends_on = [aws_codedeploy_app.this]
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = "721_codedeploy_deployment_group_red"
  service_role_arn       = aws_iam_role.codedeploy_service.arn
  deployment_config_name = aws_codedeploy_deployment_config.this.id

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  alarm_configuration {
    alarms  = ["721_alarm1_red", "721_alarm2_red"]
    enabled = true
  }

  depends_on = [aws_codedeploy_app.this, aws_cloudwatch_metric_alarm.this1, aws_cloudwatch_metric_alarm.this2, aws_iam_role.codedeploy_service]
}

resource "aws_cloudwatch_metric_alarm" "this1" {
  alarm_name          = "721_alarm1_red"
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

resource "aws_cloudwatch_metric_alarm" "this2" {
  alarm_name          = "721_alarm2_red"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  unit                = "Count"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "This metric monitors Lambda errors."
}
