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
      CustodianRule    = "ecc-aws-031-security_group_ingress_is_restricted_traffic_to_microsoft_ds_port_445"
      ComplianceStatus = "Green"
    }
  }
}