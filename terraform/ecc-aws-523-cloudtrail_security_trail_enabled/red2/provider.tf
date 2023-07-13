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
      CustodiaRule     = "ecc-aws-523-cloudtrail_security_trail_enabled"
      ComplianceStatus = "Red2"
    }
  }
}