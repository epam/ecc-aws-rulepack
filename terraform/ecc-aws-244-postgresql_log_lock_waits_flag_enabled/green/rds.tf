resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  identifier                      = "database-244-green"
  engine                          = "postgres"
  engine_version                  = "13.3"
  instance_class                  = "db.t3.micro"
  allocated_storage               = 10
  storage_type                    = "gp2"
  db_name                         = "green244"
  username                        = "root"
  password                        = random_password.this.result
  skip_final_snapshot             = true
  parameter_group_name            = aws_db_parameter_group.this.id
  enabled_cloudwatch_logs_exports = ["postgresql"]

  depends_on = [aws_db_parameter_group.this]
}

resource "aws_db_parameter_group" "this" {
  name   = "parameter-group-244-green"
  family = "postgres13"

  parameter {
    name  = "log_lock_waits"
    value = "1"
  }
}
