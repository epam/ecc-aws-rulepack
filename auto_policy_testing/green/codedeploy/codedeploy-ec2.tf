resource "aws_codedeploy_app" "this2" {
  compute_platform = "Server"
  name             = "${module.naming.resource_prefix.codedeploy}-app-2"
}

resource "aws_codedeploy_deployment_config" "this2" {
  deployment_config_name = "${module.naming.resource_prefix.codedeploy}-config-2"
  compute_platform       = "Server"

  minimum_healthy_hosts {
    type  = "FLEET_PERCENT"
    value = "70"
  }
}

resource "aws_codedeploy_deployment_group" "this2" {
  app_name               = aws_codedeploy_app.this2.name
  deployment_group_name  = "${module.naming.resource_prefix.codedeploy}-deploy-group-2"
  service_role_arn       = aws_iam_role.this1.arn
  deployment_config_name = aws_codedeploy_deployment_config.this2.id
}

resource "aws_codedeploy_deployment_config" "this3" {
  deployment_config_name = "${module.naming.resource_prefix.codedeploy}-config-3"
  compute_platform       = "Server"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 1
  }
}

resource "aws_codedeploy_deployment_group" "this3" {
  app_name               = aws_codedeploy_app.this2.name
  deployment_group_name  = "${module.naming.resource_prefix.codedeploy}-deploy-group-3"
  service_role_arn       = aws_iam_role.this1.arn
  deployment_config_name = aws_codedeploy_deployment_config.this2.id
}

resource "aws_codedeploy_deployment_group" "this4" {
  app_name               = aws_codedeploy_app.this2.name
  deployment_group_name  = "${module.naming.resource_prefix.codedeploy}-deploy-group-4"
  service_role_arn       = aws_iam_role.this1.arn
  deployment_config_name = "CodeDeployDefault.OneAtATime"
}

resource "aws_codedeploy_deployment_group" "this5" {
  app_name               = aws_codedeploy_app.this2.name
  deployment_group_name  = "${module.naming.resource_prefix.codedeploy}-deploy-group-5"
  service_role_arn       = aws_iam_role.this1.arn
  deployment_config_name = aws_codedeploy_deployment_config.this2.id
}