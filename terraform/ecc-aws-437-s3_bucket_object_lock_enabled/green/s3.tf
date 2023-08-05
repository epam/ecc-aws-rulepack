resource "aws_s3_bucket" "this" {
  bucket              = "437-bucket-${random_integer.this.result}-green"
  object_lock_enabled = true

}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 7
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}