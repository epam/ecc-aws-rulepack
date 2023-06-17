# After running "terraform deploy" wait around 5-10 minutes for AWS Config recorder status to become "FAILURE" 

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.this]
}

resource "aws_s3_bucket" "this" {
  bucket        = "bucket-459-red"
  force_destroy = true

}

resource "aws_config_delivery_channel" "this" {
  name           = "default"
  s3_bucket_name = aws_s3_bucket.this.bucket
}

resource "aws_config_configuration_recorder" "this" {
  name     = "default"
  role_arn = aws_iam_role.this.arn
}