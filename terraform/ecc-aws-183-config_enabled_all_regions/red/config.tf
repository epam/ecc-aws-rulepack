resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = false
  depends_on = [aws_config_delivery_channel.this]
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_s3_bucket" "this" {
  bucket        = "bucket-183-red"
  force_destroy = true

}

resource "aws_config_delivery_channel" "this" {
  name           = "183_delivery_channel_red"
  s3_bucket_name = aws_s3_bucket.this.bucket
  depends_on     = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder" "this" {
  name     = "183_configuration_recorder_red"
  role_arn = aws_iam_role.this.arn

  recording_group{
    all_supported=false
    resource_types = ["AWS::RDS::DBInstance"]
  }
}

resource "aws_iam_role" "this" {
  name = "183_role_red"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "this" {
  name = "183_policy_red"
  role = aws_iam_role.this.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.this.arn}",
        "${aws_s3_bucket.this.arn}/*"
      ]
    }
  ]
}
POLICY
}