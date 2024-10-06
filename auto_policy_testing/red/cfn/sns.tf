resource "aws_sns_topic" "this" {
  name = module.naming.resource_prefix.sns
}