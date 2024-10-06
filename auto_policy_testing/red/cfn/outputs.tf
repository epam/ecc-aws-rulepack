output "cfn" {
  value = {
    cfn = aws_cloudformation_stack.this.id
    ecc-aws-477-cloudformation_stack_notification_check = [aws_cloudformation_stack.this.id, aws_cloudformation_stack.this2.id]
  }
}
