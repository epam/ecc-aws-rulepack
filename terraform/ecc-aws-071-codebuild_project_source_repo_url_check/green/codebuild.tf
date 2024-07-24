# Requires manual set up:
# 1. terraform init
# 2. terraform apply
# 3. Open the AWS CodeBuild console at https://console.aws.amazon.com/codesuite/codebuild/home.
# 4. In the navigation pane, choose 'Build projects'.
# 5. Choose 'c7n-071-codebuild-green' project.
# 6. Choose 'Edit'.
# 7. Under the 'Source 1 - Primary', for 'Repository' select 'Connect using OAuth'.
# 8. Choose 'Connect to GitHub' and 'Confirm'.
# 9. Under 'Source 2', for 'Repository' select 'Connect using OAuth'.
# 10. Choose 'Connect to Bitbucket' and 'Confirm'.
# 9. Choose 'Update project'.

# Requires manual clean up:
# 1. Delete configured CodeBuild credentials:
# BITBUCKET_arn=$(aws codebuild list-source-credentials --query 'sourceCredentialsInfos[?serverType==`BITBUCKET`].arn' --output text)
# GITHUB_arn=$(aws codebuild list-source-credentials --query 'sourceCredentialsInfos[?serverType==`GITHUB`].arn' --output text)
# aws codebuild delete-source-credentials --arn $BITBUCKET_arn
# aws codebuild delete-source-credentials --arn $GITHUB_arn
# 2. Check if they were cleaned: aws codebuild list-source-credentials


resource "aws_codebuild_project" "this1" {
  name = "c7n-071-codebuild-green"
  service_role = aws_iam_role.this.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
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
