resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  identifier                      = "database-236-green"
  engine                          = "postgres"
  engine_version                  = "13.12"
  instance_class                  = "db.t3.micro"
  allocated_storage               = 10
  storage_type                    = "gp2"
  db_name                         = "green236"
  username                        = "root"
  password                        = random_password.this.result
  multi_az                        = false
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["postgresql"]
  parameter_group_name            = aws_db_parameter_group.this.id

}

resource "aws_db_parameter_group" "this" {
  name   = "parameter-group-236-green"
  family = "postgres13"

  parameter {
    name  = "debug_pretty_print"
    value = "1"
  }

}
