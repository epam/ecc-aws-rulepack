output "graphql-api" {
  value = {
    graphql-api = aws_appsync_graphql_api.this.arn
  }
}
