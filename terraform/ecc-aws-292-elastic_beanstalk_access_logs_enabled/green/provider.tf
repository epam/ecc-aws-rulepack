terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6"
    }
  }
}

provider "aws"{
  profile = var.profile
  region = var.default-region

  default_tags {
    tags = {
      CustodianRule    = "ecc-aws-292-elastic_beanstalk_access_logs_enabled"
      ComplianceStatus = "Green"
    }
  }
}
