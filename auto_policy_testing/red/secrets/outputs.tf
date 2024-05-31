output "secrets" {
  value = {
    secrets-manager                                       = aws_secretsmanager_secret.this1.arn,
    ecc-aws-219-secrets_manager_successful_rotation_check = aws_secretsmanager_secret.this2.arn
  }
}
