resource "aws_api_gateway_rest_api" "this" {
  name = "${module.naming.resource_prefix.apigw}-1"
  minimum_compression_size = -1
  
  endpoint_configuration {
    types = ["REGIONAL"]
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

resource "aws_api_gateway_resource" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "mydemoresource"
}

resource "aws_api_gateway_method" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = false
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
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    caching_enabled      = true
    logging_level   = "OFF"
  }
}


resource "aws_api_gateway_rest_api" "this2" {
  name = "${module.naming.resource_prefix.apigw}-2"
  
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

resource "aws_api_gateway_deployment" "this2" {
  rest_api_id = aws_api_gateway_rest_api.this2.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this2.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this2" {
  deployment_id         = aws_api_gateway_deployment.this2.id
  rest_api_id           = aws_api_gateway_rest_api.this2.id
  stage_name            = "${module.naming.resource_prefix.apigw}-stage-2"
}