resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_rds_cluster" "this" {
  cluster_identifier              = "aurora-cluster-276-red"
  engine                          = "aurora-postgresql"
  engine_version                  = "13.10"
  database_name                   = "red276"
  master_username                 = "root"
  master_password                 = random_password.this.result
  apply_immediately               = true
  skip_final_snapshot             = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.id
  enabled_cloudwatch_logs_exports = ["postgresql"]
}

resource "aws_rds_cluster_parameter_group" "this" {
  name   = "cluster-parameter-group-276-red"
  family = "aurora-postgresql13"

  parameter {
    name  = "log_statement"
    value = "all"
  }
}

resource "aws_rds_cluster_instance" "this" {
  identifier              = "database-276-red"
  cluster_identifier      = aws_rds_cluster.this.id
  engine                  = aws_rds_cluster.this.engine
  engine_version          = aws_rds_cluster.this.engine_version
  instance_class          = "db.t3.medium"
  apply_immediately       = true
  db_parameter_group_name = aws_db_parameter_group.this.id
}

resource "aws_db_parameter_group" "this" {
  name   = "parameter-group-276-red"
  family = "aurora-postgresql13"
}
