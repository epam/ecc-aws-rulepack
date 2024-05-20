resource "aws_s3_bucket" "this2" {
  bucket        = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}-2"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "this2" {
  bucket = aws_s3_bucket.this2.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "this2" {
  bucket = aws_s3_bucket.this2.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "this" {
  depends_on = [aws_s3_bucket_versioning.this]

  role   = aws_iam_role.this.arn
  bucket = aws_s3_bucket.this.id

  rule {
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.this2.arn
      storage_class = "STANDARD"
    }
  }
}

resource "aws_s3_bucket_acl" "this2" {
  bucket = aws_s3_bucket.this2.id
  acl    = "log-delivery-write"

  depends_on = [aws_s3_bucket_ownership_controls.this2]
}

resource "aws_s3_bucket_notification" "this2" {
  bucket = aws_s3_bucket.this2.id
  queue {
    queue_arn     = aws_sqs_queue.this.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}
