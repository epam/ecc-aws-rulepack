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
      CustodianRule    = "ecc-aws-028-security_group_ingress_is_restricted_traffic_to_dns_port_53"
      ComplianceStatus = "Green"
    }
  }
}