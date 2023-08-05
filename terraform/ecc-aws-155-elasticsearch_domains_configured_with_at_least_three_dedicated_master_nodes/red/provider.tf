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
      CustodianRule    = "ecc-aws-155-elasticsearch_domains_configured_with_at_least_three_dedicated_master_nodes"
      ComplianceStatus = "Red"
    }
  }
}