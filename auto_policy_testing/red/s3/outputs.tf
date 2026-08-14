output "s3" {
  value = {
    s3                                   = aws_s3_bucket.this.id
    ecc-aws-463-bucket_not_dns_compliant = aws_s3_bucket.not_dns_compliant.id
  }
}
