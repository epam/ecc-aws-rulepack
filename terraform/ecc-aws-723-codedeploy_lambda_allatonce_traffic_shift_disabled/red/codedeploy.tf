resource "aws_codedeploy_app" "this" {
  compute_platform = "Lambda"
  name             = "723_codedeploy-app_red"
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = "723_codedeploy_deployment_group_red"
  service_role_arn       = aws_iam_role.codedeploy_service.arn
  deployment_config_name = "CodeDeployDefault.LambdaAllAtOnce"

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  depends_on = [aws_codedeploy_app.this, aws_iam_role.codedeploy_service]
}

