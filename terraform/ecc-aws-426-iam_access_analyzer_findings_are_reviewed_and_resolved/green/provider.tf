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
      CustodianRule     = "ecc-aws-426-iam_access_analyzer_findings_are_reviewed_and_resolved"
      ComplianceStatus = "Green"
    }
  }
}