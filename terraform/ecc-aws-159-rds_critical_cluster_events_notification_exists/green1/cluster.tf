resource "aws_rds_cluster" "default" {
  cluster_identifier      = "cluster-159-green1"
  engine                  = "aurora-postgresql"
  database_name           = "cluster159green1"
  master_username         = "root"
  master_password         = random_password.this.result
  skip_final_snapshot  = true
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}
resource "aws_sns_topic" "this" {
  name = "159-sns-topic-green1"
}

resource "aws_sqs_queue" "this" {
  name = "159-sqs-green1"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.this.arn
}

resource "aws_db_event_subscription" "this" {
  name      = "db-event-subscription-159-green1"
  sns_topic = aws_sns_topic.this.arn
  source_type = "db-cluster"
}
