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
      CustodianRule    = "ecc-aws-548-ebs_volumes_are_of_type_gp3_instead_of_gp2"
      ComplianceStatus = "Green"
    }
  }
}
