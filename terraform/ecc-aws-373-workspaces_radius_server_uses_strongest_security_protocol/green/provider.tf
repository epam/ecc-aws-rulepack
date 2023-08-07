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
      CustodiaRule     = "ecc-aws-546-workspaces_radius_server_uses_strongest_security_protocol"
      ComplianceStatus = "Green"
    }
  }
}