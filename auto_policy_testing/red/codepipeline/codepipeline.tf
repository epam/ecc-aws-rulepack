resource "aws_codepipeline" "this" {
  name     = "${module.naming.resource_prefix.codepipeline}"
  role_arn = aws_iam_role.this.arn
  pipeline_type = "V1"

  artifact_store {
    location = aws_s3_bucket.this.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.this.arn
        FullRepositoryId = "epam/ecc-aws-rulepack"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = "${module.naming.resource_prefix.codebuild}"
      }
    }
  }
}

resource "aws_codestarconnections_connection" "this" {
  name          = "codepipeline-green"
  provider_type = "GitHub"
}