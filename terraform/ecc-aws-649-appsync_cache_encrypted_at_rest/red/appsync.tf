resource "aws_appsync_graphql_api" "this" {
  name                = "649_appsync-graphql-api_red"
  authentication_type = "API_KEY"
}

resource "aws_appsync_api_cache" "this" {
  api_id               = aws_appsync_graphql_api.this.id
  api_caching_behavior = "FULL_REQUEST_CACHING"
  type                 = "SMALL"
  ttl                  = 900
}