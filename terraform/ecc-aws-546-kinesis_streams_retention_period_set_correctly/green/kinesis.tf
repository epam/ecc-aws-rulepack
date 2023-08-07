resource "aws_kinesis_stream" "this" {
  name             = "546_kinesis_green"
  shard_count      = 1
  retention_period = 24 * 90 # hours * days
}
