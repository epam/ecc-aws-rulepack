resource "aws_s3_bucket" "this" {
  bucket        = "482-bucket-${random_integer.this.result}-green"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}

resource "aws_cloudwatch_log_group" "this" {
  name = "log-group-482-green"
}

resource "aws_codebuild_project" "this1" {
  name = "482_codebuilt_green1"
  service_role = aws_iam_role.this.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }


  source {
    type            = "GITHUB"
    location        = "https://github.com/mitchellh/packer.git"
  }

  logs_config {
    cloudwatch_logs {
      status      = "ENABLED"
      group_name  = "log-group-482-green"
    }
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type         = "LINUX_CONTAINER"
  }

  depends_on = [aws_s3_bucket.this]
}

resource "aws_codebuild_project" "this1" {
  name = "482_codebuilt_green1"
  service_role = aws_iam_role.this.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }


  source {
    type            = "GITHUB"
    location        = "https://github.com/mitchellh/packer.git"
  }

  logs_config {
    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.this.id}/build-log"
    }
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type         = "LINUX_CONTAINER"
  }

  depends_on = [aws_s3_bucket.this]
}

resource "aws_iam_role" "this" {
  name = "482_role_green"

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