resource "aws_s3_bucket" "this" {
  bucket        = "406-bucket-${random_integer.this.result}-green"
  force_destroy = true

}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_object" "this" {
  bucket = "406-bucket-green"
  key    = "my-certs.zip"
  source = "${path.module}/my-certs.zip"
  etag   = filemd5("${path.module}/my-certs.zip")

  depends_on = [aws_s3_bucket.this]
}