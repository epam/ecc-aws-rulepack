resource "aws_sqs_queue" "this" {
  name                      = "432_sqs_green"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}