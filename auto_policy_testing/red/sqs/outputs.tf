output "sqs" {
  value = {
    sqs = aws_sqs_queue.this.arn
  }
}
