resource "aws_api_gateway_rest_api" "edge" {
  name = "250_api_edge_red"
  
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_rest_api" "regional" {
  name = "250_api_regional_red"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}