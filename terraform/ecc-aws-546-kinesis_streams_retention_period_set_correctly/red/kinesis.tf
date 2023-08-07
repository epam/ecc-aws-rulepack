resource "aws_kinesis_stream" "this" {
  name        = "546_kinesis_red"
  shard_count = 1
}
