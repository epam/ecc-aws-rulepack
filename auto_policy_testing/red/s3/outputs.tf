output "s3" {
  value = {
    s3                                                         = aws_s3_bucket.this.id
    ecc-aws-043-s3_bucket_lifecycle                            = [aws_s3_bucket.this.id, aws_s3_bucket.this2.id]
    ecc-aws-112-s3_bucket_versioning_mfa_delete_enabled        = [aws_s3_bucket.this.id, aws_s3_bucket.this2.id]
    ecc-aws-142-s3_buckets_configured_with_block_public_access = [aws_s3_bucket.this.id, aws_s3_bucket.this2.id]
    ecc-aws-463-bucket_not_dns_compliant                       = aws_s3_bucket.this2.id
  }
}
