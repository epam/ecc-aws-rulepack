resource "aws_s3_bucket" "this" {
  bucket = "bucket-280-red"
  force_destroy = "true"
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = true
}