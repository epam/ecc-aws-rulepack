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
      CustodianRule    = "ecc-aws-131-security_group_unrestricted_ingress_traffic_to_memcached_ports"
      ComplianceStatus = "Red"
    }
  }
}