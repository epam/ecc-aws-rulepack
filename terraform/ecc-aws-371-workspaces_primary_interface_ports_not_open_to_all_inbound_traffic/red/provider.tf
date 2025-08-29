terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.default-region
  default_tags {
    tags = {
      CustodianRule     = "ecc-aws-543-workspaces_primary_interface_ports_not_open_to_all_inbound_traffic"
      ComplianceStatus = "Red"

    }
  }
}