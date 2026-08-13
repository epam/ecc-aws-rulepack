# Covers 119 (aws/kinesis), 418 (no tags), 436 (no shard metrics), 546 (short retention)
resource "aws_kinesis_stream" "this" {
  name            = module.naming.resource_prefix.kinesis
  shard_count     = 1
  encryption_type = "KMS"
  kms_key_id      = "alias/aws/kinesis"
  provider        = aws.provider2
}

# ecc-aws-120-kinesis_server_data_at_rest_has_sse (conflicts with 119 on a single stream)
resource "aws_kinesis_stream" "no_sse" {
  name            = "${module.naming.resource_prefix.kinesis}-nosse"
  shard_count     = 1
  encryption_type = "NONE"
  provider        = aws.provider2
}

resource "aws_kinesis_video_stream" "this" {
  name                    = module.naming.resource_prefix.kinesis_video
  data_retention_in_hours = 1
  media_type              = "video/h264"
  provider                = aws.provider2
}
