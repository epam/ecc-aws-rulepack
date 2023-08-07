resource "aws_apigatewayv2_api" "this" {
  name                       = "376_websocket_red"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id = aws_apigatewayv2_api.this.id
  name   = "376_websocket_api_stage_red"

  default_route_settings {
    logging_level = "ERROR"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "376_log_group_red"
  retention_in_days = 7
}
