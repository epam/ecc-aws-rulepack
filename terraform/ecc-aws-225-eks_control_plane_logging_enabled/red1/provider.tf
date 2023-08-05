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
      CustodianRule    = "ecc-aws-225-eks_control_plane_logging_enabled"
      ComplianceStatus = "Red1"
    }
  }
}