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
      CustodianRule    = "ecc-aws-328-unused_ebs_volumes"
      ComplianceStatus = "Red"
      Name             = "489-unused_ebs_volumes_red"
    }
  }
}
