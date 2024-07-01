output "codebuild" {
  value = {
    codebuild = aws_codebuild_project.this1.arn,
    ecc-aws-483-codebuild_project_s3_logs_encrypted = aws_codebuild_project.this2.arn
  }
}
