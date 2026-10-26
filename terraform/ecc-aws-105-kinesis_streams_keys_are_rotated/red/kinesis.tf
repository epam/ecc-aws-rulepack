resource "aws_kinesis_stream" "kinesis1" {
  name        = "105_kinesis1_stream_red"
  shard_count = 1
}

resource "aws_kinesis_stream" "kinesis2" {
  name            = "105_kinesis2_stream_red"
  shard_count     = 1
  encryption_type = "KMS"
  kms_key_id      = aws_kms_key.this.id
}


resource "aws_kms_key" "this" {
  description             = "105_kms_red"
  deletion_window_in_days = 10
  enable_key_rotation     = false
}