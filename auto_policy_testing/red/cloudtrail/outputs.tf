output "cloudtrail" {
  value = {
    cloudtrail = aws_cloudtrail.this.arn
  }
}
