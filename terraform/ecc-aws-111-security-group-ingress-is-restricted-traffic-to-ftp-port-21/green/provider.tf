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
      CustodianRule    = "ecc-aws-111-security-group-ingress-is-restricted-traffic-to-ftp-port-21"
      ComplianceStatus = "Green"
    }
  }
}