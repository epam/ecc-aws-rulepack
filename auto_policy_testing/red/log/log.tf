resource "aws_cloudwatch_log_group" "this" {
  provider = aws.provider2
  name     = module.naming.resource_prefix.cloudwatch_log
}
