output "message" {
  value = {
    message-broker                               = aws_mq_broker.this.arn
    ecc-aws-340-mq_broker_logging_enabled        = [aws_mq_broker.this.arn, aws_mq_broker.this2.arn]
    ecc-aws-434-mq_broker_latest_version         = [aws_mq_broker.this.arn, aws_mq_broker.this2.arn]
    ecc-aws-433-mq_broker_active_deployment_mode = [aws_mq_broker.this.arn, aws_mq_broker.this2.arn]
  }
}
