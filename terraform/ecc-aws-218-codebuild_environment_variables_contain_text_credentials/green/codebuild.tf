resource "aws_s3_bucket" "input_bucket" {
  bucket        = "bucket-codebuild-input-bucket-216-green"
  force_destroy = true
}
resource "aws_s3_bucket" "output_bucket" {
  bucket        = "bucket-codebuild-output-bucket-216-green"
  force_destroy = true
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.input_bucket.id
  key    = "MessageUtil.zip"
  source = "MessageUtil.zip"
}

resource "aws_codebuild_project" "this" {
  name = "218_codebuilt_green"

  service_role = aws_iam_role.this.arn

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.output_bucket.id
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "SOME_KEY1"
      value = "SOME_VALUE1"
    }
  }
  source {
    type     = "S3"
    location = "${aws_s3_bucket.input_bucket.id}/MessageUtil.zip"
  }

  depends_on = [aws_s3_bucket.input_bucket, aws_s3_bucket.output_bucket]
}

resource "aws_iam_role" "this" {
  name = "218_role_green"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}