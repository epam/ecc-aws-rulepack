resource "aws_rds_cluster" "default" {
  cluster_identifier      = "cluster-159-red"
  engine                  = "aurora-postgresql"
  database_name           = "cluster159red"
  master_username         = "roott"
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
  name = "159-sns-topic-red"
}

resource "aws_db_event_subscription" "this" {
  name      = "db-event-subscription-159-red"
  sns_topic = aws_sns_topic.this.arn
  source_type = "db-cluster"

  event_categories = [
    "failure",
  ]
}
