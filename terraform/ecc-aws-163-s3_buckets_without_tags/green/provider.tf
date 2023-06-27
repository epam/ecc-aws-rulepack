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
  region  = var.default-region
  
  default_tags {
    tags = {
      CustodianRule = "ecc-aws-163-s3_buckets_without_tags"
      ComplianceStatus = "Green"
    }
  }
}