resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${module.naming.resource_prefix.ecs}"
  retention_in_days = 7
  kms_key_id = data.terraform_remote_state.common.outputs.kms_key_arn
}

resource "aws_s3_bucket" "this" {
  bucket        = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}-1"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}
