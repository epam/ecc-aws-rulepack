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
      CustodiaRule     = "ecc-aws-541-workspaces_cloudwatch_integration"
      ComplianceStatus = "Red"
    }
  }
}