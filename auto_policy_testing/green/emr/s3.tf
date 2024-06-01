resource "aws_s3_bucket" "this" {
  bucket        = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}-1"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_object" "this" {
  bucket = aws_s3_bucket.this.id
  key    = "my-certs.zip"
  source = "${path.module}/my-certs.zip"
  etag   = filemd5("${path.module}/my-certs.zip")
}