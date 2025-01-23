resource "aws_codebuild_source_credential" "bitbucket_passw" {
  auth_type   = "BASIC_AUTH"
  server_type = "BITBUCKET"
  token       = "password-test"
  user_name   = "username-test"
}


resource "aws_codebuild_project" "this" {
  name = "c7n-071-codebuild-red-1"
  service_role = aws_iam_role.this.arn
  
  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type       = "BITBUCKET"
    location   = var.bitbucket_location
  }

  secondary_sources {
    source_identifier = "test1"
    type       = "GITLAB"
    location   = "https://gitlab.com/test/test.git"
  }
}

resource "aws_iam_role" "this" {
  name = "071_c7n_role_red-1"

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
