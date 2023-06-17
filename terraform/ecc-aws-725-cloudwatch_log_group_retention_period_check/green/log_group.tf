resource "aws_cloudwatch_log_group" "this" {
  name              = "cloudwatch_725_log_group_green"
  retention_in_days = 180
}
