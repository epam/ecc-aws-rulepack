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
      CustodianRule    = "ecc-aws-318-oracle_sec_max_failed_login_attempts_flag_is_3_or_less"
      ComplianceStatus = "Green"
    }
  }
}
