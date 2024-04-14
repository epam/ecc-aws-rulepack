resource "aws_apigatewayv2_api" "this1" {
  name          = "${module.naming.resource_prefix.apigwv2}-1"
  protocol_type = "HTTP"
}

# ecc-aws-376-api_gateway_http_api_and_websocket_api_logs_not_enabled
resource "aws_apigatewayv2_stage" "this1" {
  api_id = aws_apigatewayv2_api.this1.id
  name   = "${module.naming.resource_prefix.apigwv2_stage}-1"
}

resource "aws_apigatewayv2_api" "this2" {
  name                       = "${module.naming.resource_prefix.apigwv2}-2"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

# ecc-aws-376-api_gateway_http_api_and_websocket_api_logs_not_enabled
resource "aws_apigatewayv2_stage" "this2" {
  api_id = aws_apigatewayv2_api.this2.id
  name   = "${module.naming.resource_prefix.apigwv2_stage}-2"

  default_route_settings {
    logging_level = "ERROR"
  }
}
