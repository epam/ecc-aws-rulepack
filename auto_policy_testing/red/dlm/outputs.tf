output "dlm-policy" {
  value = {
    dlm-policy = aws_dlm_lifecycle_policy.this.id
  }
}
