resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  identifier                      = "database-324-green"
  engine                          = "oracle-ee"
  engine_version                  = "19.0.0.0.ru-2019-10.rur-2019-10.r1"
  instance_class                  = "db.t3.small"
  allocated_storage               = 10
  storage_type                    = "gp2"
  db_name                         = "green324"
  username                        = "root"
  password                        = random_password.this.result
  skip_final_snapshot             = true
  parameter_group_name            = aws_db_parameter_group.this.id

  depends_on = [aws_db_parameter_group.this]
}

resource "aws_db_parameter_group" "this" {
  name   = "parameter-group-324-green"
  family = "oracle-ee-19"

  parameter {
    apply_method = "pending-reboot"
    name  = "resource_limit"
    value = "TRUE"
  }

}
