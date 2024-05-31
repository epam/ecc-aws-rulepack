resource "aws_rds_cluster" "aurora-mysql" {
  cluster_identifier                  = "${module.naming.resource_prefix.rds_cluster}-aurora-mysql"
  availability_zones                  = [data.aws_availability_zones.this.names[0], data.aws_availability_zones.this.names[1], data.aws_availability_zones.this.names[2]]
  engine                              = "aurora-mysql"
  engine_version                      = data.aws_rds_engine_version.aurora-mysql.version_actual
  master_username                     = "root"
  master_password                     = random_password.this.result
  apply_immediately                   = true
  skip_final_snapshot                 = true
  storage_encrypted                   = true
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.aurora-mysql.id
  enabled_cloudwatch_logs_exports     = ["audit", "error", "general", "slowquery"]
  iam_database_authentication_enabled = true
  backtrack_window                    = 600
  copy_tags_to_snapshot               = true
  port                                = 6033
  deletion_protection                 = true
}

resource "null_resource" "this2" {
  triggers = {
    rds = aws_rds_cluster.aurora-mysql.cluster_identifier
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws rds modify-db-cluster --db-cluster-identifier ${self.triggers.rds} --no-deletion-protection"
  }

  depends_on = [aws_rds_cluster.aurora-mysql]
}

data "aws_rds_engine_version" "aurora-mysql" {
  engine = "aurora-mysql"
  latest = true
}

resource "aws_rds_cluster_parameter_group" "aurora-mysql" {
  name   = "${module.naming.resource_prefix.rds_param_grp}-aurora-mysql"
  family = data.aws_rds_engine_version.aurora-mysql.parameter_group_family

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

data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_rds_cluster_instance" "aurora-mysql1" {
  identifier              = "${module.naming.resource_prefix.rds_instance}-aurora-mysql1"
  cluster_identifier      = aws_rds_cluster.aurora-mysql.id
  engine                  = aws_rds_cluster.aurora-mysql.engine
  engine_version          = aws_rds_cluster.aurora-mysql.engine_version
  instance_class          = "db.t3.medium"
  apply_immediately       = true
  db_parameter_group_name = aws_db_parameter_group.aurora-mysql.id
  availability_zone       = data.aws_availability_zones.this.names[0]
}

resource "aws_rds_cluster_instance" "aurora-mysql2" {
  identifier              = "${module.naming.resource_prefix.rds_cluster}-aurora-mysql2"
  cluster_identifier      = aws_rds_cluster.aurora-mysql.id
  engine                  = aws_rds_cluster.aurora-mysql.engine
  engine_version          = aws_rds_cluster.aurora-mysql.engine_version
  instance_class          = "db.t3.medium"
  apply_immediately       = true
  db_parameter_group_name = aws_db_parameter_group.aurora-mysql.id
  availability_zone       = data.aws_availability_zones.this.names[1]
}

resource "aws_db_parameter_group" "aurora-mysql" {
  name   = "${module.naming.resource_prefix.rds_param_grp}-aurora-mysql"
  family = data.aws_rds_engine_version.aurora-mysql.parameter_group_family

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
