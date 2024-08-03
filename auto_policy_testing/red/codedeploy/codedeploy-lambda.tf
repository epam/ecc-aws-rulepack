resource "aws_codedeploy_app" "this1" {
  compute_platform = "Lambda"
  name             = "${module.naming.resource_prefix.codedeploy}-app-1"
}

resource "aws_codedeploy_deployment_config" "this1" {
  deployment_config_name = "${module.naming.resource_prefix.codedeploy}-config-1"
  compute_platform       = "Lambda"

  traffic_routing_config {
    type = "AllAtOnce"
  }
}

resource "aws_cloudwatch_metric_alarm" "this1" {
  alarm_name          = "${module.naming.resource_prefix.cw_alarm}-1"
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

resource "aws_codedeploy_deployment_group" "this1" {
  app_name               = aws_codedeploy_app.this1.name
  deployment_group_name  = "${module.naming.resource_prefix.codedeploy}-deploy-group-1"
  service_role_arn       = aws_iam_role.this1.arn
  deployment_config_name = "CodeDeployDefault.LambdaAllAtOnce"

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  auto_rollback_configuration {
    enabled = false
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = [aws_cloudwatch_metric_alarm.this1.alarm_name]
    enabled = true
  }
}


resource "aws_codedeploy_deployment_group" "this2" {
  app_name               = aws_codedeploy_app.this1.name
  deployment_group_name  = "${module.naming.resource_prefix.codedeploy}-deploy-group-2"
  service_role_arn       = aws_iam_role.this1.arn
  deployment_config_name = aws_codedeploy_deployment_config.this1.id

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  alarm_configuration {
    alarms  = [aws_cloudwatch_metric_alarm.this1.alarm_name]
    enabled = true
  }
}


resource "aws_codedeploy_deployment_group" "this3" {
  app_name               = aws_codedeploy_app.this1.name
  deployment_group_name  = "${module.naming.resource_prefix.codedeploy}-deploy-group-3"
  service_role_arn       = aws_iam_role.this1.arn
  deployment_config_name = aws_codedeploy_deployment_config.this1.id

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}