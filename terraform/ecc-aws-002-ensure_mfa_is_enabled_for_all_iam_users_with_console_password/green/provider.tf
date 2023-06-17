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
      CustodianRule    = "ecc-aws-002-ensure_mfa_is_enabled_for_all_iam_users_with_console_password"
      ComplianceStatus = "Green"
    }
  }
}

