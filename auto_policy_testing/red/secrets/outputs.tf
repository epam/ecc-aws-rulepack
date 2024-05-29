output "secrets" {
  value = {
    secrets-manager = aws_secretsmanager_secret.this.arn
  }
}
