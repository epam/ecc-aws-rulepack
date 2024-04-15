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
      CustodianRule    = "ecc-aws-253-glue_data_catalog_encrypted_with_kms_customer_master_keys"
      ComplianceStatus = "Red"
    }
  }
}