resource "aws_cloudwatch_log_group" "this" {
  name     = "${module.naming.resource_prefix.cloudwatch_log}"
  provider = aws.provider2
}
