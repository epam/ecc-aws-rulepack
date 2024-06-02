resource "aws_iam_role" "this" {
  name = "${module.naming.resource_prefix.graphql_api}"

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "appsync.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppSyncPushToCloudWatchLogs"
  role       = aws_iam_role.this.name
}

resource "aws_appsync_graphql_api" "this" {
  name                = "${module.naming.resource_prefix.graphql_api}"
  authentication_type = "API_KEY"

  log_config {
    cloudwatch_logs_role_arn = aws_iam_role.this.arn
    field_log_level          = "ERROR"
    exclude_verbose_content  = false
  }
}

resource "aws_appsync_api_cache" "this" {
  api_id                     = aws_appsync_graphql_api.this.id
  api_caching_behavior       = "FULL_REQUEST_CACHING"
  type                       = "SMALL"
  ttl                        = 900
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
}

resource "aws_wafv2_web_acl" "this" {
  name  = "${module.naming.resource_prefix.graphql_api}"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${module.naming.resource_prefix.graphql_api}"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "this" {
  resource_arn = aws_appsync_graphql_api.this.arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
