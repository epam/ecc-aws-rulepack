output "message" {
  value = {
    message-broker = aws_mq_broker.this.arn
  }
}
