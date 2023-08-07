resource "aws_codedeploy_app" "this" {
  compute_platform = "Lambda"
  name             = "484_codedeploy-app_green"
}

resource "aws_codedeploy_deployment_config" "this" {
  deployment_config_name = "484_deployment-config_green"
  compute_platform       = "Lambda"

  traffic_routing_config {
    type = "AllAtOnce"
  }

  depends_on = [aws_codedeploy_app.this]
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = "484_codedeploy_deployment_group_green"
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
    alarms  = ["484_alarm1_green", "484_alarm2_green"]
    enabled = true
  }

  depends_on = [aws_codedeploy_app.this, aws_cloudwatch_metric_alarm.this1, aws_cloudwatch_metric_alarm.this2, aws_iam_role.codedeploy_service]
}

resource "aws_cloudwatch_metric_alarm" "this1" {
  alarm_name          = "484_alarm1_green"
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
  alarm_name          = "484_alarm2_green"
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

locals {
  app_content_raw = {
    "version" : 0.0,
    "Resources" : [{
      "484_lambda_fun_green" : {
        "Type" : "AWS::Lambda::Function",
        "Properties" : {
          "Name" : "484_lambda_fun_green",
          "Alias" : "484_lambda_alias_green",
          "CurrentVersion" : "1",
          "TargetVersion" : "2"
        }
      }
    }]
  }

  appspec_content = replace(jsonencode(local.app_content_raw), "\"", "\\\"")
  appspec_sha256  = sha256(jsonencode(local.app_content_raw))

}


resource "null_resource" "deployment" {
  provisioner "local-exec" {
    command     = "aws deploy create-deployment --application-name ${aws_codedeploy_app.this.name}  --deployment-config-name ${aws_codedeploy_deployment_config.this.id} --deployment-group-name 484_codedeploy_deployment_group_green --revision '{\"revisionType\": \"AppSpecContent\", \"appSpecContent\": {\"content\": \"${local.appspec_content}\", \"sha256\": \"${local.appspec_sha256}\"}}' "
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [aws_lambda_function.this, aws_lambda_alias.this, aws_codedeploy_app.this, aws_codedeploy_deployment_group.this, aws_codedeploy_deployment_config.this]
}