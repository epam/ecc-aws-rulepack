resource "aws_db_parameter_group" "this" {
  name   = "db-parameter-group-161-green1"
  family = "mysql5.7"
}

resource "aws_sns_topic" "this" {
  name = "161_sns_topic_green1"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.test-email
}

resource "aws_db_event_subscription" "this" {
  name        = "db-event-subscription-161-green1"
  sns_topic   = aws_sns_topic.this.arn
  source_type = "db-parameter-group"

  event_categories = [
    "configuration change"
  ]
}
