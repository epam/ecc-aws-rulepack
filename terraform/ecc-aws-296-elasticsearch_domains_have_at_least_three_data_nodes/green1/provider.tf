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
      CustodianRule     = "ecc-aws-296-elasticsearch_domains_have_at_least_three_data_nodes"
      ComplianceStatus = "Green1"
    }
  }
}