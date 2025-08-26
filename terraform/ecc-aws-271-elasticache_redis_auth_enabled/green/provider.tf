terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.default-region
  default_tags {
    tags = {
      CustodianRule    = "ecc-aws-271-elasticache_redis_auth_enabled"
      ComplianceStatus = "Green"
    }
  }
}