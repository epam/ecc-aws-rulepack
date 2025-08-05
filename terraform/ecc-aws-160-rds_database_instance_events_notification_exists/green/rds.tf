resource "aws_db_instance" "this" {
  identifier           = "instance-160-green"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.4"
  instance_class       = "db.t3.micro"
  username             = "root"
  password             = random_password.this.result
  skip_final_snapshot  = true

  tags = {
    Name = "160_db_instance_green"
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_sns_topic" "this" {
  name = "160-sns-topic-green"
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
  name      = "db-event-subscription-160-green"
  sns_topic = aws_sns_topic.this.arn
  source_type = "db-instance"

  event_categories = [
    "maintenance",
    "configuration change",
    "failure",
  ]
}
