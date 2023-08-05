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
      CustodiaRule     = "ecc-aws-545-workspaces_api_requests_flow_through_vpc_endpoint"
      ComplianceStatus = "Red"
    }
  }
}