output "message" {
  value = {
    message-broker                                    = aws_mq_broker.this.arn
    ecc-aws-343-mq_broker_not_publicly_accessible     = aws_mq_broker.this2.arn
    ecc-aws-345-mq_broker_open_to_all_ports_protocols = aws_mq_broker.this.arn
  }
}
