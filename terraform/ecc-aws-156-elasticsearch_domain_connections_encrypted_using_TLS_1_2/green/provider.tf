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
      CustodianRule    = "ecc-aws-156-elasticsearch_domain_connections_encrypted_using_TLS_1_2"
      ComplianceStatus = "Green"
    }
  }
}