output "glue-catalog" {
  value = {
    glue-catalog = data.aws_caller_identity.this.account_id
  }
}
