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
      CustodianRule     = "ecc-aws-194-s3_bucket_should_not_allow_all_actions_from_all_principals"
      ComplianceStatus = "Red"
    }
  }
}