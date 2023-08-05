resource "aws_s3_bucket" "this" {
  bucket        = "481-bucket-${random_integer.this.result}-green"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_codebuild_project" "this" {
  name = "481_codebuilt_green"

  service_role = aws_iam_role.this.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.this.bucket
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/mitchellh/packer.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  logs_config {
    cloudwatch_logs {
      status = "DISABLED"
    }
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false

    environment_variable {
      name  = "SOME_KEY1"
      value = "SOME_VALUE1"
    }
  }


  depends_on = [aws_s3_bucket.this]
}

resource "aws_iam_role" "this" {
  name = "481_role_green"

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