resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  identifier                      = "database-352-red1"
  engine                          = "mariadb"
  engine_version                  = "10.6.10"
  instance_class                  = "db.t2.micro"
  allocated_storage               = 20
  storage_type                    = "gp2"
  db_name                         = "red1352"
  username                        = "root"
  password                        = random_password.this.result
  multi_az                        = false
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["audit", "general", "slowquery"]
  parameter_group_name            = aws_db_parameter_group.this.id
  option_group_name               = aws_db_option_group.this.id

  tags = {
    Name = "352_db_instance_red1"
  }
}

resource "aws_db_parameter_group" "this" {
  name   = "parameter-group-352-red1"
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
  name                     = "option-group-352-red1"
  engine_name              = "mariadb"
  major_engine_version     = "10.6"
}