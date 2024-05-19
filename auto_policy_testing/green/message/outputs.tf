output "message" {
  value = {
    message-broker = aws_mq_broker.this.arn
    ecc-aws-343-mq_broker_not_publicly_accessible = aws_mq_broker.this2.arn
  }
}
