resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = false
  depends_on = [aws_config_delivery_channel.this]
}

resource "aws_s3_bucket" "this" {
  bucket        = "059-bucket-${random_integer.this.result}-red1"
  force_destroy = true

}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_config_delivery_channel" "this" {
  name           = "059_delivery_channel_red1"
  s3_bucket_name = aws_s3_bucket.this.bucket
  depends_on     = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder" "this" {
  name     = "059_configuration_recorder_red1"
  role_arn = aws_iam_role.this.arn

  recording_group {
    all_supported  = false
    resource_types = ["AWS::RDS::DBInstance"]
  }
}
