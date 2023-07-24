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
	  Name = "100_ebs_volume_red"
      CustodianRule = "ecc-aws-100-ebs-volume_without_recent_snapshot"
      ComplianceStatus = "Red"
    }
  }
}