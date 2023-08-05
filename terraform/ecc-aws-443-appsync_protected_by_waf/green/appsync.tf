resource "aws_appsync_graphql_api" "this" {
  name                = "443-appsync-graphql-api-green"
  authentication_type = "API_KEY"
}

resource "aws_wafv2_web_acl" "this" {
  name  = "443-wafv2-web-acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "443-metric-name"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "this" {
  resource_arn = aws_appsync_graphql_api.this.arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
