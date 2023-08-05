resource "aws_cloudwatch_log_group" "this" {
  name              = "cloudwatch_488_log_group_red"
  retention_in_days = 7
}
