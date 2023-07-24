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
      CustodianRule     = "ecc-aws-226-security_group_changes_alarm_exists"
      ComplianceStatus = "Red"
    }
  }
}