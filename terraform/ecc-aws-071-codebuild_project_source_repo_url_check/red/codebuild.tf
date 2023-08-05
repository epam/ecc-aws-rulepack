resource "aws_codebuild_project" "a" {
  name         = "c7n-071-codebuild-a-red"

  service_role = aws_iam_role.this.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:1.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type       = "GITHUB"
    location   = var.github_location
    auth {
      type     = "OAUTH"
      resource = aws_codebuild_source_credential.source_a.arn
    }
  }
}

resource "aws_codebuild_source_credential" "source_a" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.token
}

resource "aws_codebuild_project" "b" {
  name         = "c7n-071-codebuild-b-red"

  service_role = aws_iam_role.this.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:1.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type       = "BITBUCKET"
    location   = var.bitbucket_location
    auth {
      type     = "OAUTH"
      resource = aws_codebuild_source_credential.source_b.arn
    }
  }
}

resource "aws_codebuild_source_credential" "source_b" {
  auth_type   = "BASIC_AUTH"
  server_type = "BITBUCKET"
  token       = var.user_password
  user_name   = var.user_name
}

resource "aws_iam_role" "this" {
  name = "071_role_red"

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