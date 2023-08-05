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
      CustodianRule    = "ecc-aws-513-acm_certificate_not_using_a_minimum_of_2048-bit_key_for_rsa_certificate"
      ComplianceStatus = "Green"
    }
  }
}
