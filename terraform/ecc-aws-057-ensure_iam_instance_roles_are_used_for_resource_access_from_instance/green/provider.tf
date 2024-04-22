terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws"{
  profile = var.profile
  region = var.default-region

  default_tags {
    tags = {
      CustodianRule    = "ecc-aws-057-ensure_iam_instance_roles_are_used_for_resource_access_from_instance"
      ComplianceStatus = "Green"
    }
  }
}