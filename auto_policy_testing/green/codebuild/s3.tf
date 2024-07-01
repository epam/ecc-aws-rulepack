resource "aws_s3_bucket" "this" {
  bucket        = "${module.naming.resource_prefix.codebuild}-${random_integer.this.result}"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}
