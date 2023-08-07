resource "aws_kinesis_stream" "this" {
  name                = "436_kinesis_stream_green"
  shard_count         = 1
  shard_level_metrics = [
    "ALL",
  ]
}
