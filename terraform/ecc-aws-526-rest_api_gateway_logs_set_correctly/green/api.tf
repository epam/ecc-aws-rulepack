resource "aws_api_gateway_rest_api" "this" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "apiGatewayRestApi526Green"
      version = "1.0"
    }
    paths = {
      "/path1" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }
  })

  name = "apiGatewayRestApi526Green"
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id         = aws_api_gateway_deployment.this.id
  rest_api_id           = aws_api_gateway_rest_api.this.id
  stage_name            = "apiGatewayStage526Green"
  cache_cluster_enabled = true
  cache_cluster_size    = "0.5"

  access_log_settings{
    destination_arn = aws_cloudwatch_log_group.this.arn
    format = "$context.identity.sourceIp,$context.identity.caller,$context.identity.user,$context.requestTime,$context.httpMethod,$context.resourcePath,$context.protocol,$context.status,$context.responseLength,$context.requestId"
  }

  depends_on = [aws_cloudwatch_log_group.this]
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    logging_level   = "ERROR"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "526_log_group_green"
  retention_in_days = 7
}

