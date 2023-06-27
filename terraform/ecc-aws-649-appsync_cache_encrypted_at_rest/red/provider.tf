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
      CustodiaRule     = "ecc-aws-649-appsync_cache_encrypted_at_rest"
      ComplianceStatus = "Red"
    }
  }
}
