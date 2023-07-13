terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.default-region
  default_tags {
    tags = {
      CustodiaRule     = "ecc-aws-549-api_gateway_http_api_and_websocket_api_logs_set_correctly"
      ComplianceStatus = "Red"
    }
  }
}