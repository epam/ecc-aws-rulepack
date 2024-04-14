output "ecr" {
  value = {
    ecr = aws_ecr_repository.this.arn
  }
}
