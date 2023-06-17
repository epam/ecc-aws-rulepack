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
      CustodianRule    = "ecc-aws-115-security-group-ingress-is-restricted_traffic_to_mysql_db_port_3306"
      ComplianceStatus = "Green"
    }
  }
}