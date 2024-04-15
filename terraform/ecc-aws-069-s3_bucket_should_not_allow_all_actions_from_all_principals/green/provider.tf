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
      CustodianRule    = "ecc-aws-069-s3_bucket_should_not_allow_all_actions_from_all_principals"
      ComplianceStatus = "Green"
    }
  }
}