resource "aws_sqs_queue" "this" {
  name                              = "${module.naming.resource_prefix.sqs}-1"
  delay_seconds                     = 90
  max_message_size                  = 2048
  message_retention_seconds         = 86400
  receive_wait_time_seconds         = 10
  kms_master_key_id                 = data.terraform_remote_state.common.outputs.kms_key_arn
  kms_data_key_reuse_period_seconds = 300

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.this2.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sqs_queue" "this2" {
  name                              = "${module.naming.resource_prefix.sqs}-2"
}
