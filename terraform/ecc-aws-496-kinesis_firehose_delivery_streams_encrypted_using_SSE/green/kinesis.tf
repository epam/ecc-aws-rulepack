resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = "496_kinesis_firehose_green"
  destination = "extended_s3"
  server_side_encryption{
    enabled = true
  }
  extended_s3_configuration{
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.this.arn
  }
}

