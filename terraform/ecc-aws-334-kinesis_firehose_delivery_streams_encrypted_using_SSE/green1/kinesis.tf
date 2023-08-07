resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = "334_kinesis_firehose_green1"
  destination = "extended_s3"

  kinesis_source_configuration{
    kinesis_stream_arn = aws_kinesis_stream.this.arn
    role_arn = aws_iam_role.this.arn
  }
  extended_s3_configuration{
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.this.arn
  }
}

resource "aws_kinesis_stream" "this" {
  name             = "334_kinesis_stream_green1"
  shard_count      = 1
  encryption_type  = "NONE"
}
