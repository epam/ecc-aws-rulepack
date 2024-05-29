output "cloudtrail" {
  value = {
    cloudtrail                              = aws_cloudtrail.this1.arn
    ecc-aws-374-cloudtrail_logs_data_events = aws_cloudtrail.this2.arn
    ecc-aws-544-cloudtrail_delivery_failing = aws_cloudtrail.this2.arn
  }
}
