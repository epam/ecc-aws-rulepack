resource "aws_kinesis_stream" "this" {
  name             = "120_kinesis_stream_red"
  shard_count      = 1
  encryption_type  = "NONE"
}
