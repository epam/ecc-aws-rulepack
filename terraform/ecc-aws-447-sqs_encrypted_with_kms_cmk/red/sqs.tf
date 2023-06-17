resource "aws_sqs_queue" "this" {
  name                      = "447_sqs_red"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  kms_master_key_id                 = "alias/aws/sqs"
  kms_data_key_reuse_period_seconds = 300
}
resource "aws_sqs_queue_policy" "this" {
  queue_url = "${aws_sqs_queue.this.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.this.arn}"
      }
  ]
}
POLICY
}
