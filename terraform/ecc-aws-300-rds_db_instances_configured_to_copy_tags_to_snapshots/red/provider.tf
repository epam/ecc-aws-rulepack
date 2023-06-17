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
      CustodianRule    = "ecc-aws-300-rds_db_instances_configured_to_copy_tags_to_snapshots"
      ComplianceStatus = "Red"
    }
  }
}