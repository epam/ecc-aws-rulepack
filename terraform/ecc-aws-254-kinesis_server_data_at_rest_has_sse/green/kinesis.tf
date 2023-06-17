resource "aws_kinesis_stream" ".this" {
  name             = "254_kinesis_stream_green"
  shard_count      = 1
  encryption_type  = "KMS"
  kms_key_id       = aws_kms_key.this.id
}

resource "aws_kms_key" "this" {
  description             = "254_kms_key_green"
  deletion_window_in_days = 10
}
