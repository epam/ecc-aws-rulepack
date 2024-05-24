output "codebuild" {
  value = {
    codebuild = [
      aws_codebuild_project.a.arn,
      aws_codebuild_project.b.arn
    ]
  }
}
