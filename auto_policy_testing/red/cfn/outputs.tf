output "cfn" {
  value = {
    cnf = aws_cloudformation_stack.this.id
  }
}
