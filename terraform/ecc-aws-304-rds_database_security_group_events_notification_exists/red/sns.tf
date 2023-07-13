resource "aws_sns_topic" "this" {
  name = "304_sns_topic_red"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.test-email
}

resource "aws_db_event_subscription" "this" {
  name        = "db-event-subscription-304-red"
  sns_topic   = aws_sns_topic.this.arn
  source_type = "db-security-group"

  event_categories = [
    "failure"
  ]
}