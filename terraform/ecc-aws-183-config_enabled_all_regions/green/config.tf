resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.this]
}

resource "aws_s3_bucket" "this" {
  bucket        = "bucket-183-green"
  force_destroy = true

}

resource "aws_config_delivery_channel" "this" {
  name           = "183_delivery_channel_green"
  s3_bucket_name = aws_s3_bucket.this.bucket
  depends_on     = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder" "this" {
  name     = "183_configuration_recorder_green"
  role_arn = aws_iam_role.this.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}
