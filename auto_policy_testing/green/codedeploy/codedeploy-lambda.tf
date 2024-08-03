resource "aws_codedeploy_app" "this1" {
  compute_platform = "Lambda"
  name             = "${module.naming.resource_prefix.codedeploy}-app-1"
}

resource "aws_codedeploy_deployment_config" "this1" {
  deployment_config_name = "${module.naming.resource_prefix.codedeploy}-config-1"
  compute_platform       = "Lambda"

  traffic_routing_config {
    type = "TimeBasedLinear"

    time_based_linear {
      interval   = 10
      percentage = 10
    }
  }
}

resource "aws_codedeploy_deployment_group" "this1" {
  app_name               = aws_codedeploy_app.this1.name
  deployment_group_name  = "${module.naming.resource_prefix.codedeploy}-deploy-group-1"
  service_role_arn       = aws_iam_role.this1.arn
  deployment_config_name = aws_codedeploy_deployment_config.this1.id

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_STOP_ON_ALARM"]
  }

  alarm_configuration {
    alarms  = [aws_cloudwatch_metric_alarm.this1.alarm_name]
    enabled = true
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

locals {
  app_content_raw = {
    "version": 0.0,
    "Resources" : [{
      "${aws_lambda_function.this.function_name}": {
        "Type" : "AWS::Lambda::Function",
        "Properties": {
          "Name": "${aws_lambda_function.this.function_name}",
          "Alias": "${aws_lambda_alias.this.name}",
          "CurrentVersion": "${aws_lambda_function.this.version}",
          "TargetVersion": "${data.aws_lambda_function.this.version}"
        }
      }
    }]
  }

  appspec_content = replace(jsonencode(local.app_content_raw), "\"", "\\\"")
  appspec_sha256  = sha256(jsonencode(local.app_content_raw))

}


resource "null_resource" "deployment" {
  provisioner "local-exec" {
    command     = "aws deploy create-deployment --application-name ${aws_codedeploy_app.this1.name}  --deployment-config-name ${aws_codedeploy_deployment_config.this1.id} --deployment-group-name ${aws_codedeploy_deployment_group.this1.deployment_group_name} --revision '{\"revisionType\": \"AppSpecContent\", \"appSpecContent\": {\"content\": \"${local.appspec_content}\", \"sha256\": \"${local.appspec_sha256}\"}}' "
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [aws_lambda_alias.this, aws_codedeploy_deployment_group.this1]
}