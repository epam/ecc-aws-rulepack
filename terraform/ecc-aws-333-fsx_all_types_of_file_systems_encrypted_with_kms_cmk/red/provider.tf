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
      CustodianRule    = "ecc-aws-333-fsx_all_types_of_file_systems_encrypted_with_kms_cmk"
      ComplianceStatus = "Red"
    }
  }
}