resource "aws_kinesis_stream" "this" {
  name                = "${module.naming.resource_prefix.kinesis}"
  shard_count         = 1
  encryption_type     = "KMS"
  kms_key_id          = "alias/aws/kinesis"
  provider            = aws.provider2
}

resource "aws_kinesis_video_stream" "this" {
  name                    = "${module.naming.resource_prefix.kinesis_video}"
  data_retention_in_hours = 1
  media_type              = "video/h264"
  provider                = aws.provider2
}
