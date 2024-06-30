# Requires manual set up:
# 1. terraform init
# 2. terraform apply
# 3. Open the AWS CodeBuild console at https://console.aws.amazon.com/codesuite/codebuild/home.
# 4. In the navigation pane, choose 'Build projects'.
# 5. Choose 'c7n-071-codebuild-green-1' project
# 6. Choose 'Edit'
# 7. Under the 'Source 1 - Primary', for 'Repository' select 'Connect using OAuth'
# 8. Choose 'Connect to GitHub'
# 9. Choose 'Update project'


resource "aws_codebuild_project" "this" {
  name = "c7n-071-codebuild-green-1"
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
    type       = "GITHUB"
    location   = var.github_location
  }

  secondary_sources {
    source_identifier = "test1"
    type       = "GITHUB"
    location   = "https://github.com/test/test.git"
  }
}

resource "aws_iam_role" "this" {
  name = "071_c7n_role_green-1"

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
