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
      CustodianRule    = "ecc-aws-113-security-group-ingress-is-restricted-traffic-to-microsoft-ds-port-445"
      ComplianceStatus = "Green"
    }
  }
}