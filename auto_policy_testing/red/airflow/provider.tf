terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }

   backend "s3" {
    bucket = ""
    key    = ""
    region = ""
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = module.naming.default_tags
  }
}

provider "aws" {
  region = var.region
  alias  = "provider2"
}