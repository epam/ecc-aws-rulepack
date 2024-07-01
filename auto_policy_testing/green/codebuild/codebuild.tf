# An OAUTH connection is not supported by the API and must be created using the CodeBuild console.

# https://docs.aws.amazon.com/codebuild/latest/userguide/access-tokens.html#access-tokens-github


resource "aws_codebuild_project" "this1" {
  name         = "${module.naming.resource_prefix.codebuild}-1"
  service_role = aws_iam_role.this.arn

  artifacts {
    location            = aws_s3_bucket.this.id
    type                = "S3"
    path                = "/"
    packaging           = "ZIP"
    encryption_disabled = false
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
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
      group_name  = aws_cloudwatch_log_group.this.name
    }
  }

  source {
    type       = "BITBUCKET"
    location   = var.bitbucket_location
  }
}

resource "aws_codebuild_project" "this2" {
  name         = "${module.naming.resource_prefix.codebuild}-2"
  service_role = aws_iam_role.this.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "DISABLED"
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

resource "aws_cloudwatch_log_group" "this" {
  name = "${module.naming.resource_prefix.cw_log_group}"
}