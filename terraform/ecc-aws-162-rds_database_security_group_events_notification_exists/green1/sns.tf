resource "aws_sns_topic" "this" {
  name = "162_sns_topic_green1"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.test-email
}

resource "aws_db_event_subscription" "this" {
  name        = "db-event-subscription-162-green1"
  sns_topic   = aws_sns_topic.this.arn
  source_type = "db-security-group"

  event_categories = [
    "configuration change",
    "failure"
  ]
}