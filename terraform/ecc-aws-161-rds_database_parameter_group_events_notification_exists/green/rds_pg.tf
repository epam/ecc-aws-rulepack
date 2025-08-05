resource "aws_db_parameter_group" "this" {
  name   = "db-parameter-group-161-green"
  family = "mysql8.4"
}

resource "aws_sns_topic" "this" {
  name = "161_sns_topic_green"
}

resource "aws_sqs_queue" "this" {
  name = "160-sqs-green"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.this.arn
}

resource "aws_db_event_subscription" "this" {
  name        = "db-event-subscription-161-green"
  sns_topic   = aws_sns_topic.this.arn
  source_type = "db-parameter-group"
}
