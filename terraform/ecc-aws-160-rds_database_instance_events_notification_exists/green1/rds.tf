resource "aws_db_instance" "default" {
  identifier           = "instance-160-green1"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.4"
  instance_class       = "db.t3.micro"
  db_name              = "database160green1"
  username             = "root"
  password             = random_password.this.result
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  tags = {
    Name = "160_db_instance_green1"
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_sns_topic" "this" {
  name = "160-sns-topic-green1"
}

resource "aws_sqs_queue" "this" {
  name = "160-sqs-green1"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.this.arn
}
resource "aws_db_event_subscription" "this" {
  name      = "db-event-subscription-160-green1"
  sns_topic = aws_sns_topic.this.arn

  source_type = "db-instance"
  
  event_categories = [
    "maintenance",
    "configuration change",
    "failure",
  ]
}
