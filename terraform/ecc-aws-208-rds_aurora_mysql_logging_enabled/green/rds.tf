resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_rds_cluster" "this" {
  cluster_identifier              = "aurora-cluster-208-green"
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.mysql_aurora.2.12.1"
  database_name                   = "green208"
  master_username                 = "root"
  master_password                 = random_password.this.result
  apply_immediately               = true
  skip_final_snapshot             = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.id
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

}

resource "aws_rds_cluster_parameter_group" "this" {
  name   = "cluster-parameter-group-208-green"
  family = "aurora-mysql5.7"

  parameter {
    name  = "general_log"
    value = "1"
  }
  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }

}

resource "aws_rds_cluster_instance" "this" {
  identifier              = "database-208-green"
  cluster_identifier      = aws_rds_cluster.this.id
  engine                  = aws_rds_cluster.this.engine
  engine_version          = aws_rds_cluster.this.engine_version
  instance_class          = "db.t2.small"
  apply_immediately       = true
  db_parameter_group_name = aws_db_parameter_group.this.id

}

resource "aws_db_parameter_group" "this" {
  name   = "parameter-group-208-green"
  family = "aurora-mysql5.7"

  parameter {
    name  = "general_log"
    value = "1"
  }
  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }

}
