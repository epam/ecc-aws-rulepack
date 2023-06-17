resource "aws_kinesis_stream" "this" {
  name        = "613_kinesis1_stream_green"
  shard_count = 1
}
