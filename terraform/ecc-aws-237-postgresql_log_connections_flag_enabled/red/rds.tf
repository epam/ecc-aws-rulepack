resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  identifier                      = "database-237-red"
  engine                          = "postgres"
  engine_version                  = "13.12"
  instance_class                  = "db.t3.micro"
  allocated_storage               = 10
  storage_type                    = "gp2"
  db_name                         = "red237"
  username                        = "root"
  password                        = random_password.this.result
  multi_az                        = false
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["postgresql"]
  parameter_group_name            = aws_db_parameter_group.this.id
}

resource "aws_db_parameter_group" "this" {
  name   = "parameter-group-237-red"
  family = "postgres13"
}
