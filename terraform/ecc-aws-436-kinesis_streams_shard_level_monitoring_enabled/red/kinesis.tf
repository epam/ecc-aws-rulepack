resource "aws_kinesis_stream" "this" {
  name                = "436_kinesis_stream_red"
  shard_count         = 1
}
