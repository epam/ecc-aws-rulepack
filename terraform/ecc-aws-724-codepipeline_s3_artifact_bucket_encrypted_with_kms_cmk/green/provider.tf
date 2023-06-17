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
      CustodianRule    = "ecc-aws-724-codepipeline_s3_artifact_bucket_encrypted_with_kms_cmk"
      ComplianceStatus = "Green"
    }
  }
}
