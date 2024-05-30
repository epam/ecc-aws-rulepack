resource "aws_kinesis_stream" "this1" {
  provider        = aws.provider2
  name            = "${module.naming.resource_prefix.kinesis}-1"
  shard_count     = 1
  encryption_type = "KMS"
  kms_key_id      = "alias/aws/kinesis"
}

resource "aws_kinesis_stream" "this2" {
  name        = "${module.naming.resource_prefix.kinesis}-2"
  shard_count = 1
}

resource "aws_kinesis_video_stream" "this" {
  provider                = aws.provider2
  name                    = module.naming.resource_prefix.kinesis_video
  data_retention_in_hours = 1
  media_type              = "video/h264"

}
