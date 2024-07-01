# CodeBuild only allows a single credential to be saved in a given AWS account in a given region

resource "aws_codebuild_source_credential" "github" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = "test"
}

resource "aws_codebuild_source_credential" "bitbucket_passw" {
  auth_type   = "BASIC_AUTH"
  server_type = "BITBUCKET"
  token       = "password-test"
  user_name   = "username-test"
}

resource "aws_codebuild_project" "this1" {
  provider     = aws.provider2
  name = "${module.naming.resource_prefix.codebuild}-1"
  service_role = aws_iam_role.this.arn
  
  artifacts {
    type                = "S3"
    location            = aws_s3_bucket.this.id
    encryption_disabled = true
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_ACCESS_KEY_ID"
      value = "xxxxxxxxx"
    }
    environment_variable {
      name  = "AWS_SECRET_ACCESS_KEY"
      value = "xxxxxxxxxxxxx"
    }
  }

  logs_config {
    cloudwatch_logs {
      status = "DISABLED"
    }
    s3_logs {
      status   = "DISABLED"
    }
  }

  source {
    type       = "GITHUB"
    location   = var.github_location
  }

  secondary_sources {
    source_identifier = "test1"
    type       = "BITBUCKET"
    location   = var.bitbucket_location
  }
  secondary_sources {
    source_identifier = "test2"
    type       = "GITLAB"
    location   = "https://gitlab.com/test/test.git"
  }
}

resource "aws_codebuild_project" "this2" {
  name = "${module.naming.resource_prefix.codebuild}-2"
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
      encryption_disabled = true
    }
  }

  source {
    type       = "BITBUCKET"
    location   = var.bitbucket_location
  }

  secondary_sources {
    source_identifier = "test1"
    type       = "BITBUCKET"
    location   = "https://username:token@bitbucket.org/test1/test.git"
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
