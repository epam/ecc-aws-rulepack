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
      CustodianRule    = "ecc-aws-278-iam_access_analyzer_findings_are_reviewed_and_resolved"
      ComplianceStatus = "Green"
    }
  }
}