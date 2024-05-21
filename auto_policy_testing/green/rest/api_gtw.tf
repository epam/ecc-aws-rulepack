resource "aws_api_gateway_client_certificate" "this" {
  description = module.naming.resource_prefix.iam_cert
}

resource "aws_api_gateway_rest_api" "this" {
  name = "${module.naming.resource_prefix.apigw}-1"
  minimum_compression_size = 100
  
  endpoint_configuration {
    types = ["EDGE"]
  }

  body = jsonencode({
    openapi = "3.0.1"
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
  stage_name            = "${module.naming.resource_prefix.apigw}-stage-1"
  client_certificate_id = aws_api_gateway_client_certificate.this.id
  cache_cluster_enabled = true
  cache_cluster_size    = 0.5
  xray_tracing_enabled  = true

  access_log_settings{
    destination_arn = aws_cloudwatch_log_group.this.arn
    format = "$context.identity.sourceIp,$context.identity.caller,$context.identity.user,$context.requestTime,$context.httpMethod,$context.resourcePath,$context.protocol,$context.status,$context.responseLength,$context.requestId"
  }

  depends_on = [aws_cloudwatch_log_group.this]
}

resource "aws_cloudwatch_log_group" "this" {
  name = module.naming.resource_prefix.cw_log_group
  retention_in_days = 7
}

resource "aws_wafregional_web_acl_association" "this" {
  resource_arn = aws_api_gateway_stage.this.arn
  web_acl_id   = data.terraform_remote_state.common.outputs.wafregional_acl_id
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    caching_enabled      = true
    cache_data_encrypted = true
    logging_level   = "ERROR"
  }
}

resource "aws_api_gateway_resource" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "${module.naming.resource_prefix.apigw}-1"
}

resource "aws_api_gateway_method" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = true
}


resource "aws_api_gateway_rest_api" "this2" {
  name = "${module.naming.resource_prefix.apigw}-2"
  
  endpoint_configuration {
    types = ["PRIVATE"]
  }
}