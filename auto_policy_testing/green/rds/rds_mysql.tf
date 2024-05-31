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
  multi_az                            = true
  backup_retention_period             = 7
  publicly_accessible                 = false
  copy_tags_to_snapshot               = true
  skip_final_snapshot                 = true
  apply_immediately                   = true
  delete_automated_backups            = true
  storage_encrypted                   = true
  kms_key_id                          = data.terraform_remote_state.common.outputs.kms_key_arn
  monitoring_role_arn                 = aws_iam_role.this.arn
  monitoring_interval                 = 30
  enabled_cloudwatch_logs_exports     = ["audit", "error", "general", "slowquery"]
  parameter_group_name                = aws_db_parameter_group.mysql.id
  iam_database_authentication_enabled = true
  auto_minor_version_upgrade          = true
  deletion_protection                 = true
}

resource "aws_db_parameter_group" "mysql" {
  name   = "${module.naming.resource_prefix.rds_param_grp}-mysql"
  family = data.aws_rds_engine_version.mysql.parameter_group_family

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
  parameter {
    apply_method = "pending-reboot"
    name         = "sql_mode"
    value        = "ALLOW_INVALID_DATES,STRICT_ALL_TABLES,IGNORE_SPACE"
  }
}

data "aws_rds_engine_version" "mysql" {
  engine = "mysql"
  latest = true
}

resource "aws_db_snapshot" "mysql" {
  db_instance_identifier = aws_db_instance.mysql.identifier
  db_snapshot_identifier = "${module.naming.resource_prefix.rds_instance}-mysql"
}

resource "null_resource" "this1" {
  triggers = {
    rds = aws_db_instance.mysql.identifier
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws rds modify-db-instance --db-instance-identifier ${self.triggers.rds} --no-deletion-protection"
  }

  depends_on = [aws_db_instance.mysql]
}