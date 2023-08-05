resource "aws_kinesis_stream" "this" {
  name        = "418_kinesis1_stream_red"
  shard_count = 1
}
