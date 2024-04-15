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
      CustodianRule    = "ecc-aws-132-public_instance_with_sensitive_service_is_exposed_to_entire_internet"
      ComplianceStatus = "Red"
    }
  }
}