resource "aws_kinesis_stream" "this" {
  name             = "253_kinesis_stream_red"
  shard_count      = 1
  encryption_type  = "KMS"
  kms_key_id       = "alias/aws/kinesis"
}