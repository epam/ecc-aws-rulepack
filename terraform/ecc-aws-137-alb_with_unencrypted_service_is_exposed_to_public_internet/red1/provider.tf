terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.default-region

  default_tags {
    tags = {
      CustodianRule    = "ecc-aws-137-alb_with_unencrypted_service_is_exposed_to_public_internet"
      ComplianceStatus = "Red"
    }
  }
}