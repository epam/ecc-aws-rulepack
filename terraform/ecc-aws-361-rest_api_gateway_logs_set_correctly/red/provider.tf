terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
} 

provider "aws"{
  profile = var.profile
  region = var.default-region  
  default_tags {
    tags = {
      CustodianRule    = "ecc-aws-361-rest_api_gateway_logs_set_correctly"
      ComplianceStatus = "Red"
    }
  }
}