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
      CustodianRule    = "ecc-aws-151-security_group_ingress_is_restricted_traffic_to_containerized_workloads"
      ComplianceStatus = "Red"
    }
  }
}