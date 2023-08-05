resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  identifier                      = "database-204-green"
  engine                          = "mysql"
  engine_version                  = "8.0.26"
  instance_class                  = "db.t3.micro"
  allocated_storage               = 10
  storage_type                    = "gp2"
  db_name                         = "green204"
  username                        = "root"
  password                        = random_password.this.result
  multi_az                        = false
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["audit","error","general","slowquery"]
  parameter_group_name            = aws_db_parameter_group.this.id

  tags = {
    Name = "204_db_instance_green"
  }
}

resource "aws_db_parameter_group" "this" {
  name   = "parameter-group-204-green"
  family = "mysql8.0"

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
