resource "aws_codedeploy_app" "this" {
  compute_platform = "Server"
  name             = "722_codedeploy-app_green"
}

resource "aws_codedeploy_deployment_config" "this" {
  deployment_config_name = "722_deployment-config_green"
  compute_platform       = "Server"

  minimum_healthy_hosts {
    type  = "FLEET_PERCENT"
    value = "50"
  }

  depends_on = [aws_codedeploy_app.this]
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = "722_codedeploy_deployment_group_green"
  service_role_arn       = aws_iam_role.codedeploy_service.arn
  deployment_config_name = aws_codedeploy_deployment_config.this.id


  depends_on = [aws_codedeploy_app.this]
}

