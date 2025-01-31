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
      CustodianRule    = "ecc-aws-146-no_acls_allow_ingress_for_everyone_to_remote_server_administration_ports"
      ComplianceStatus = "Green"
    }
  }
}