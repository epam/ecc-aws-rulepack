resource "aws_db_instance" "mariadb" {
  identifier                      = "${module.naming.resource_prefix.rds_instance}-mariadb"
  engine                          = "mariadb"
  engine_version                  = "10.6.17"
  instance_class                  = "db.t3.micro"
  allocated_storage               = 20
  storage_type                    = "gp2"
  username                        = "root"
  password                        = random_password.this.result
  multi_az                        = false
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  parameter_group_name            = aws_db_parameter_group.mariadb.id
  option_group_name               = aws_db_option_group.mariadb.id
  delete_automated_backups        = true
}

resource "aws_db_parameter_group" "mariadb" {
  name   = "${module.naming.resource_prefix.rds_param_grp}-mariadb"
  family = "mariadb10.6"

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

resource "aws_db_option_group" "mariadb" {
  name                 = "${module.naming.resource_prefix.rds_option_grp}-mariadb"
  engine_name          = "mariadb"
  major_engine_version = "10.6"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"

    option_settings {
      name  = "SERVER_AUDIT_EVENTS"
      value = "CONNECT,QUERY,TABLE,QUERY_DDL,QUERY_DML,QUERY_DCL"
    }
  }
}
