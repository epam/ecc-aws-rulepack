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
      CustodianRule    = "ecc-aws-132-security_group_unrestricted_ingress_traffic_common_to_db_services_ports"
      ComplianceStatus = "Green"
    }
  }
}