resource "aws_sns_topic" "this" {
  name = module.naming.resource_prefix.sns
}

resource "aws_sqs_queue" "this" {
  name = module.naming.resource_prefix.sqs
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.this.arn
}
