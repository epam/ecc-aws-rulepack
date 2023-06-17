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
      CustodianRule    = "ecc-aws-539-fsx_lustre_retention_period_set_at_least_to_7_days"
      ComplianceStatus = "Red"
    }
  }
}