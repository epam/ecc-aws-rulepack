terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.default-region

  default_tags {
    tags = {
      CustodianRule    = "ecc-aws-157-rds_db_clusters_configured_to_copy_tags_to_snapshots"
      ComplianceStatus = "Red"
    }
  }
}