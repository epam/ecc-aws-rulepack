resource "aws_s3_bucket" "this2" {
  bucket        = "autotest.s3.${random_integer.this.result}.red"
  force_destroy = true
}

# resource "aws_s3_bucket_acl" "this" {
#   depends_on = [aws_s3_bucket_ownership_controls.this]

#   bucket = aws_s3_bucket.this.id
#   acl    = "private"
# }

resource "aws_s3_bucket_versioning" "this2" {
  bucket = aws_s3_bucket.this2.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this2" {
  bucket = aws_s3_bucket.this2.id

  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_lifecycle_configuration" "this2" {
  bucket = aws_s3_bucket.this2.bucket

  rule {
    id = "log"

    expiration {
      days = 90
    }

    status = "Disabled"

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}