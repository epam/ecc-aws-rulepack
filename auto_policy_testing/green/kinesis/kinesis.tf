resource "aws_kinesis_stream" "this" {
  name             = module.naming.resource_prefix.kinesis
  shard_count      = 1
  encryption_type  = "KMS"
  kms_key_id       = data.terraform_remote_state.common.outputs.kms_key_arn
  retention_period = 24 * 90 # hours * days

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingRecords",
    "IteratorAgeMilliseconds",
    "IncomingRecords",
    "ReadProvisionedThroughputExceeded",
    "WriteProvisionedThroughputExceeded",
    "OutgoingBytes"
  ]
}

resource "aws_kinesis_video_stream" "this" {
  name                    = module.naming.resource_prefix.kinesis_video
  data_retention_in_hours = 1
  media_type              = "video/h264"
}
