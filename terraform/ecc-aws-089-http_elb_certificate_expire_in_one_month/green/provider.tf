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
  region  = var.default-region
  
  default_tags {
    tags = {
      CustodianRule = "ecc-aws-089-http_load_balancer_certificate_expire_in_one_month"
      ComplianceStatus = "Green"
    }
  }
}