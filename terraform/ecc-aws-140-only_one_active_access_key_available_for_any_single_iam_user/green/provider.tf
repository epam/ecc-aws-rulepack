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
      CustodianRule    = "ecc-aws-140-only_one_active_access_key_available_for_any_single_iam_user"
      ComplianceStatus = "Green"
    }
  }
}