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
}

resource "aws_appsync_api_cache" "this" {
  api_id                     = aws_appsync_graphql_api.this.id
  api_caching_behavior       = "FULL_REQUEST_CACHING"
  type                       = "SMALL"
  ttl                        = 900
}
