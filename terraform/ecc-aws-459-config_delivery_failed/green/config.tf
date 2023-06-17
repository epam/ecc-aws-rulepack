resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.this]
}

resource "aws_s3_bucket" "this" {
  bucket        = "bucket-459-green"
  force_destroy = true

}

resource "aws_config_delivery_channel" "this" {
  name           = "default"
  s3_bucket_name = aws_s3_bucket.this.bucket
}

resource "aws_config_configuration_recorder" "this" {
  name     = "default"
  role_arn = aws_iam_role.this.arn

  recording_group{
    all_supported=false
    resource_types = ["AWS::RDS::DBInstance"]
  }
}