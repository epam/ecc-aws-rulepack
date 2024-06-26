resource "aws_kinesis_stream" "this" {
  name        = "${module.naming.resource_prefix.kinesis}"
  shard_count = 1
}
