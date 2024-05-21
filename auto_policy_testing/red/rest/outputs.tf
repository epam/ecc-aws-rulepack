output "rest" {
  value = {
    rest-api = aws_api_gateway_rest_api.this.id
    ecc-aws-116-rest_api_gateway_is_set_to_private = [aws_api_gateway_rest_api.this.id, aws_api_gateway_rest_api.this2.id]
    rest-resource = aws_api_gateway_resource.this.id
    rest-stage = aws_api_gateway_stage.this.arn
  }
}
