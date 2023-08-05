resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  identifier                      = "database-205-red"
  engine                          = "mariadb"
  engine_version                  = "10.6.10"
  instance_class                  = "db.t2.micro"
  allocated_storage               = 20
  storage_type                    = "gp2"
  db_name                         = "red205"
  username                        = "root"
  password                        = random_password.this.result
  multi_az                        = false
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["audit", "general", "slowquery"]
  parameter_group_name            = aws_db_parameter_group.this.id
  option_group_name               = aws_db_option_group.this.id

  tags = {
    Name = "205_db_instance_red"
  }
}

resource "aws_db_parameter_group" "this" {
  name   = "parameter-group-205-red"
  family = "mariadb10.6"

  parameter {
    name  = "general_log"
    value = "1"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }
}

resource "aws_db_option_group" "this" {
  name                     = "option-group-205-red"
  engine_name              = "mariadb"
  major_engine_version     = "10.6"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"

    option_settings {
      name  = "SERVER_AUDIT_EVENTS"
      value = "CONNECT,QUERY,TABLE,QUERY_DML,QUERY_DCL"
    }
  }
}