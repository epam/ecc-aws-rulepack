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
      CustodianRule    = "ecc-aws-653-mwaa_scheduler_logs_set_correctly"
      ComplianceStatus = "Green"
    }
  }
}
