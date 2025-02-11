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
      CustodianRule    = "ecc-aws-135-security_group_unrestricted_ingress_traffic_to_nfs_port"
      ComplianceStatus = "Red"
    }
  }
}