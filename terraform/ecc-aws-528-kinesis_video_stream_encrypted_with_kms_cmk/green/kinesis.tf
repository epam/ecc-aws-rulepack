resource "aws_kinesis_video_stream" "this" {
  name                    = "528_kinesis_stream_green"
  data_retention_in_hours = 1
  media_type              = "video/h264"
  kms_key_id              = aws_kms_key.this.id
}

resource "aws_kms_key" "this" {
  description             = "528_kms_key_green"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
  is_enabled              = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/k-528"
  target_key_id = aws_kms_key.this.key_id
}