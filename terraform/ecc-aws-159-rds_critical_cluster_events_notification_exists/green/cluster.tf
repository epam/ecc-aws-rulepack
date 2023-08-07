resource "aws_rds_cluster" "default" {
  cluster_identifier      = "cluster-159-green"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.11.2"
  database_name           = "cluster159green"
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
  name = "159-sns-topic-green"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.test-email
}

resource "aws_db_event_subscription" "this" {
  name      = "db-event-subscription-159-green"
  sns_topic = aws_sns_topic.this.arn
  source_type = "db-cluster"
}
