terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws"{
  profile = var.profile
  region = var.default-region

  default_tags {
    tags = {
      CustodianRule    = "ecc-aws-067-unauthorized_api_calls_alarm_exists"
      ComplianceStatus = "Green"
    }
  }
}