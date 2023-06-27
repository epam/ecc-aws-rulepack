resource "aws_s3_bucket" "this" {
  bucket = "bucket-246-red1"
  force_destroy = "true"
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}