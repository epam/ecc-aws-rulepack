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
  region  = var.default-region
  
  default_tags {
    tags = {
	  Name = "100_ebs_volume_red"
      CustodianRule    = "ecc-aws-021-ebs-volume_without_recent_snapshot"
      ComplianceStatus = "Red"
    }
  }
}