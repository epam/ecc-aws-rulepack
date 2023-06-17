resource "aws_codedeploy_app" "this" {
  compute_platform = "Lambda"
  name             = "723_codedeploy-app_green"
}

resource "aws_codedeploy_deployment_config" "this" {
  deployment_config_name = "723_deployment-config_green"
  compute_platform       = "Lambda"

  traffic_routing_config {
    type = "AllAtOnce"
  }

  depends_on = [aws_codedeploy_app.this]
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = "723_codedeploy_deployment_group_green"
  service_role_arn       = aws_iam_role.codedeploy_service.arn
  deployment_config_name = aws_codedeploy_deployment_config.this.id

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }



  depends_on = [aws_codedeploy_app.this, aws_iam_role.codedeploy_service]
}

