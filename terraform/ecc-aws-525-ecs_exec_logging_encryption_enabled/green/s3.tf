resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/525_log_group_green"
  retention_in_days = 7
  kms_key_id = aws_kms_key.this.arn
}

resource "aws_s3_bucket" "this" {
  bucket        = "525-bucket-${random_integer.this.result}-green"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
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

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt secret parameters"
  deletion_window_in_days = 7
  policy                  = templatefile("kms-policy.json", {account_id = data.aws_caller_identity.this.account_id})
  is_enabled              = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/key-525"
  target_key_id = "${aws_kms_key.this.key_id}"
}
