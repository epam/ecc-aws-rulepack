resource "aws_api_gateway_rest_api" "this" {
  name = "116_api_green"
  
  endpoint_configuration {
    types = ["PRIVATE"]
  }
}