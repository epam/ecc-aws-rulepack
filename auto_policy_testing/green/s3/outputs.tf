output "s3" {
  value = {
    s3 = aws_s3_bucket.this.id
  }
}
