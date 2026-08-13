output "log" {
  value = {
    # Custodian log-group "arn" includes the :* suffix
    log-group = "${aws_cloudwatch_log_group.this.arn}:*"
  }
}
