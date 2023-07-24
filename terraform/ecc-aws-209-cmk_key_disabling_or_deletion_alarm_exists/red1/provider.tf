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
  region = var.default-region

  default_tags {
    tags = {
      CustodianRule     = "ecc-aws-209-cmk_key_disabling_or_deletion_alarm_exists"
      ComplianceStatus = "Red1"
    }
  }
}