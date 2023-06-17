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
      CustodianRule    = "ecc-aws-279-expired_ssl_tls_certificates_stored_in_aws_iam_are_removed"
      ComplianceStatus = "Red"
    }
  }
}