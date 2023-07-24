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
      CustodianRule     = "ecc-aws-208-console_auth_failure_alarm_exists"
      ComplianceStatus = "Green"
    }
  }
}