output "codebuild" {
  value = {
    codebuild = aws_codebuild_project.this.arn
  }
}
