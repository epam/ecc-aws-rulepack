resource "aws_db_event_subscription" "this1" {
  name      = "${module.naming.resource_prefix.general}-event-subscription-1"
  sns_topic = aws_sns_topic.this1.arn
  source_type = "db-cluster"
  event_categories = [
    "failure"
  ]
}

resource "aws_db_event_subscription" "this2" {
  name      = "${module.naming.resource_prefix.general}-event-subscription-2"
  sns_topic = aws_sns_topic.this1.arn
  source_type = "db-instance"
  event_categories = [
    "availability"
  ]
}

resource "aws_db_event_subscription" "this3" {
  name      = "${module.naming.resource_prefix.general}-event-subscription-3"
  sns_topic = aws_sns_topic.this1.arn
  source_type = "db-security-group"
  event_categories = [
    "configuration change"
  ]
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "mysql" {
  identifier                          = "${module.naming.resource_prefix.rds_instance}-mysql"
  engine                              = "mysql"
  engine_version                      = data.aws_rds_engine_version.mysql.version_actual
  instance_class                      = "db.t3.micro"
  allocated_storage                   = 10
  storage_type                        = "gp2"
  username                            = "root"
  password                            = random_password.this.result
  multi_az                            = false
  publicly_accessible                 = false
  delete_automated_backups            = true
  skip_final_snapshot                 = true
}

data "aws_rds_engine_version" "mysql" {
  engine = "mysql"
  latest = true
}

resource "aws_rds_cluster" "aurora-mysql" {
  cluster_identifier                  = "${module.naming.resource_prefix.rds_cluster}-aurora-mysql"
  availability_zones                  = [data.aws_availability_zones.this.names[0], data.aws_availability_zones.this.names[1], data.aws_availability_zones.this.names[2]]
  engine                              = "aurora-mysql"
  engine_version                      = data.aws_rds_engine_version.aurora-mysql.version_actual
  master_username                     = "root"
  master_password                     = random_password.this.result
  apply_immediately                   = true
  skip_final_snapshot                 = true
}

data "aws_rds_engine_version" "aurora-mysql" {
  engine = "aurora-mysql"
  latest = true
}

data "aws_availability_zones" "this" {
  state = "available"
}