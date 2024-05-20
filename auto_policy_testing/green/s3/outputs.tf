output "s3" {
  value = {
    s3                                                         = aws_s3_bucket.this.id
    ecc-aws-142-s3_buckets_configured_with_block_public_access = [aws_s3_bucket.this.id, aws_s3_bucket.this2.id]
    ecc-aws-516-s3_event_notifications_enabled = [
      aws_s3_bucket.this.id, aws_s3_bucket.this2.id, aws_s3_bucket.this3.id
    ]
    ecc-aws-518-s3_version_lifecycle_policy_check = aws_s3_bucket.this3.id
  }
}
