resource "aws_codedeploy_app" "this" {
  compute_platform = "Server"
  name             = "485_codedeploy-app_green1"
}

resource "aws_codedeploy_deployment_config" "this" {
  deployment_config_name = "485_deployment-config_green1"
  compute_platform       = "Server"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 1
  }

  depends_on = [aws_codedeploy_app.this]
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = "485_codedeploy_deployment_group_green1"
  service_role_arn       = aws_iam_role.codedeploy_service.arn
  deployment_config_name = aws_codedeploy_deployment_config.this.id

  depends_on = [aws_codedeploy_app.this]
}

