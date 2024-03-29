resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  identifier                      = "database-231-red"
  engine                          = "postgres"
  engine_version                  = "13.12"
  instance_class                  = "db.t3.micro"
  allocated_storage               = 10
  storage_type                    = "gp2"
  db_name                         = "red231"
  username                        = "root"
  password                        = random_password.this.result
  multi_az                        = false
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["postgresql"]
  parameter_group_name            = aws_db_parameter_group.this.id

  depends_on = [aws_db_parameter_group.this]
}

resource "aws_db_parameter_group" "this" {
  name   = "parameter-group-231-red"
  family = "postgres13"

  parameter {
    name  = "log_rotation_age"
    value = "120"
  }
}
