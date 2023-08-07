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
      CustodianRule    = "ecc-aws-039-security_group_ingress_is_restricted_traffic_to_telnet_port_23"
      ComplianceStatus = "Red"
    }
  }
}