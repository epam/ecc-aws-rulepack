resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_rds_cluster" "this" {
  cluster_identifier              = "aurora-cluster-209-red"
  engine                          = "aurora-postgresql"
  engine_version                  = "13.13"
  database_name                   = "red209"
  master_username                 = "root"
  master_password                 = random_password.this.result
  apply_immediately               = true
  skip_final_snapshot             = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.id
  enabled_cloudwatch_logs_exports = ["postgresql"]

}

resource "aws_rds_cluster_parameter_group" "this" {
  name   = "cluster-parameter-group-209-red"
  family = "aurora-postgresql13"

  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1"
  }

}

resource "aws_rds_cluster_instance" "this" {
  identifier              = "database-209-red"
  cluster_identifier      = aws_rds_cluster.this.id
  engine                  = aws_rds_cluster.this.engine
  engine_version          = aws_rds_cluster.this.engine_version
  instance_class          = "db.t3.medium"
  apply_immediately       = true
  db_parameter_group_name = aws_db_parameter_group.this.id

}

resource "aws_db_parameter_group" "this" {
  name   = "parameter-group-209-red"
  family = "aurora-postgresql13"

}
