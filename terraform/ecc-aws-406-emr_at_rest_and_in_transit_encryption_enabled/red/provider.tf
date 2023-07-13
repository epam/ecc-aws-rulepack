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
      CustodianRule     = "ecc-aws-406-emr_at_rest_and_in_transit_encryption_enabled"
      ComplianceStatus = "Red"
    }
  }
}