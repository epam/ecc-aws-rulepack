output "log" {
  value = {
    log-group = aws_cloudwatch_log_group.this.arn
  }
}
