resource "aws_kinesis_stream" "this" {
  name            = "105_kinesis_stream_green"
  shard_count     = 1
  encryption_type = "KMS"
  kms_key_id      = aws_kms_key.this.id
}

resource "aws_kms_key" "this" {
  description             = "105_kms_green"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}