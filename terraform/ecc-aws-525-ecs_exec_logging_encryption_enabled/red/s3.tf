
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/525_log_group_red"
  retention_in_days = 7
}

resource "aws_s3_bucket" "this" {
  bucket        = "bucket-525-red"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}