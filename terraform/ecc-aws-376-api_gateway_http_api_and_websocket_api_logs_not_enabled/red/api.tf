resource "aws_apigatewayv2_api" "this" {
  name          = "376_http-api_red"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id = aws_apigatewayv2_api.this.id
  name   = "376-stage-red"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "376_log_group_red"
  retention_in_days = 7
}