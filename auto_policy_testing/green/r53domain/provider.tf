terraform {
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

