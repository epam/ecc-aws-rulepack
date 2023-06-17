terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
    }
  }
} 

provider "aws"{
  profile = var.profile
  region = var.default-region  
  default_tags {
    tags = {
      CustodianRule    = "ecc-aws-457-postgresql_log_min_error_statement_flag_set_correctly"
      ComplianceStatus = "Green"
    }
  }
}
