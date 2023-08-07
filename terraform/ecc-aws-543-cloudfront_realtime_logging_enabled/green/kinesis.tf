resource "aws_kinesis_stream" "this" {
  name        = "543_kinesis_green"
  shard_count = 1
}
