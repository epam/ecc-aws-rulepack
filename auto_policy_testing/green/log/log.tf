resource "aws_cloudwatch_log_group" "this" {
  name              = "${module.naming.resource_prefix.cloudwatch_log}"
  kms_key_id        = data.terraform_remote_state.common.outputs.kms_key_arn
  retention_in_days = 180
}

