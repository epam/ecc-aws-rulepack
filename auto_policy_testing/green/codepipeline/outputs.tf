output "codepipeline" {
  value = {
    codepipeline  = aws_codepipeline.this.name
  }
}
