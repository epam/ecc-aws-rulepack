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
      CustodianRule    = "ecc-aws-308-glacier_vault_access_policy_does_not_allow_actions_from_all_principals"
      ComplianceStatus = "Red"
    }
  }
}