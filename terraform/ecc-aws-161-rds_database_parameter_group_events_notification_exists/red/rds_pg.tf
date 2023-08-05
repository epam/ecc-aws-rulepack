resource "aws_db_parameter_group" "this" {
  name   = "db-parameter-group-161-red"
  family = "mysql5.7"
}

resource "aws_sns_topic" "this" {
  name = "161_sns_topic_red"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.test-email
}

resource "aws_db_event_subscription" "this" {
  name        = "db-event-subscription-161-red"
  sns_topic   = aws_sns_topic.this.arn
  source_type = "db-parameter-group"
  source_ids  = [aws_db_parameter_group.this.id]
}

resource "aws_db_instance" "this" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_name                = "database161red"
  username               = "root"
  password               = random_password.this.result
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.this.id]
  identifier             = "rds-instance-161-red"

  tags = {
    Name  = "161_instance_red"
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}