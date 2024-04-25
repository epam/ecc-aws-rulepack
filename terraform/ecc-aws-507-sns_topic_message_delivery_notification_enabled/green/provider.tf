terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.default-region
  default_tags {
    tags = {
      CustodianRule    = "ecc-aws-507-sns_topic_message_delivery_notification_enabled"
      ComplianceStatus = "Green"
    }
  }
}
