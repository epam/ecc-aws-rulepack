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
      CustodianRule    = "ecc-aws-320-oracle_sec_protocol_error_trace_action_flag_set_to_log"
      ComplianceStatus = "Red"
    }
  }
}