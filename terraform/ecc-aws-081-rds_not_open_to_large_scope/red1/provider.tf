terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
    }
  }
}

provider "aws"{
  profile = var.profile
  region  = var.default-region
  
  default_tags {
    tags = {
      CustodianRule = "ecc-aws-081-rds_not_open_to_large_scope"
      ComplianceStatus = "Red1"
    }
  }
}
