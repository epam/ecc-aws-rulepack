resource "aws_apigatewayv2_api" "this1" {
  name          = "549_http-api_green"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "this1" {
  api_id = aws_apigatewayv2_api.this1.id
  name   = "549-stage-green"

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.this1.arn
    format          = "$context.identity.sourceIp,$context.identity.caller,$context.identity.user,$context.requestTime,$context.httpMethod,$context.resourcePath,$context.protocol,$context.status,$context.responseLength,$context.requestId"
  }
}

resource "aws_cloudwatch_log_group" "this1" {
  name              = "549_log_group_green1"
  retention_in_days = 7
}

resource "aws_apigatewayv2_api" "this2" {
  name                       = "549_websocket_green"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_stage" "this2" {
  api_id = aws_apigatewayv2_api.this2.id
  name   = "549_websocket_api_stage_green"

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.this2.arn
    format          = "$context.identity.sourceIp,$context.identity.caller,$context.identity.user,$context.requestTime,$context.httpMethod,$context.resourcePath,$context.protocol,$context.status,$context.responseLength,$context.requestId"
  }
  default_route_settings {
    logging_level = "ERROR"
  }
}

resource "aws_cloudwatch_log_group" "this2" {
  name              = "549_log_group_green2"
  retention_in_days = 7
}
