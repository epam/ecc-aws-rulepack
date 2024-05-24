resource "aws_codebuild_project" "a" {
  name         = "${module.naming.resource_prefix.codebuild}"

  service_role = aws_iam_role.this.arn

  artifacts {
    location            = aws_s3_bucket.this.bucket
    type                = "S3"
    path                = "/"
    packaging           = "ZIP"
    encryption_disabled = false
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.this.bucket
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:1.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false

    
    environment_variable {
      name  = "SOME_KEY1"
      value = "SOME_VALUE1"
    }
  }

  logs_config {
    cloudwatch_logs {
      status      = "ENABLED"
      group_name  = "log-group-482-green"
      stream_name = "log-stream-482-green"
    }

    s3_logs {
      status              = "ENABLED"
      location            = "${aws_s3_bucket.this.id}/build-log"
      encryption_disabled = false
    }
  }

  source {
    type       = "GITHUB"
    location   = var.github_location
  }
}

resource "aws_codebuild_project" "b" {
  name         = "${module.naming.resource_prefix.codebuild}-2"

  service_role = aws_iam_role.this.arn

  artifacts {
    location            = aws_s3_bucket.this.bucket
    type                = "S3"
    path                = "/"
    packaging           = "ZIP"
    encryption_disabled = false
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:1.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false

    
    environment_variable {
      name  = "SOME_KEY1"
      value = "SOME_VALUE1"
    }
  }

  logs_config {
    cloudwatch_logs {
      status      = "ENABLED"
      group_name  = "log-group-482-green"
      stream_name = "log-stream-482-green"
    }

    s3_logs {
      status              = "ENABLED"
      location            = "${aws_s3_bucket.this.id}/build-log"
      encryption_disabled = false
    }
  }

  source {
    type       = "BITBUCKET"
    location   = var.bitbucket_location
  }
}


resource "aws_iam_role" "this" {
  name = "${module.naming.resource_prefix.codebuild}"

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

resource "aws_s3_bucket" "this" {
  bucket        = "${module.naming.resource_prefix.codebuild}-${random_integer.this.result}"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}
