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
      CustodianRule    = "ecc-aws-114-k8s_cluster_network_firewall_inbound_rule_permissive_to_all_traffic"
      ComplianceStatus = "Red"
    }
  }
}