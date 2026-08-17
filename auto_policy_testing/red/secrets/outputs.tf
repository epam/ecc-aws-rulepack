output "secrets" {
  value = {
    secrets-manager                                       = aws_secretsmanager_secret.this.arn
    ecc-aws-219-secrets_manager_successful_rotation_check = aws_secretsmanager_secret.rotation_failing.arn
  }
}
