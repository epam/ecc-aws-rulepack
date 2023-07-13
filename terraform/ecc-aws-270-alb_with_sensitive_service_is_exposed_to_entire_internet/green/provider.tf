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
      CustodianRule     = "ecc-aws-270-public_alb_with_sensative_service_is_exposed_to_entire_internet"
      ComplianceStatus = "Green"
    }
  }
}