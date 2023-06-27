resource "aws_appsync_graphql_api" "this" {
  name                = "650_appsync-graphql-api_green"
  authentication_type = "API_KEY"
}

resource "aws_appsync_api_cache" "this" {
  api_id                     = aws_appsync_graphql_api.this.id
  api_caching_behavior       = "FULL_REQUEST_CACHING"
  type                       = "SMALL"
  ttl                        = 900
  transit_encryption_enabled = true
}