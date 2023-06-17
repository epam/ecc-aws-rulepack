resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  identifier                      = "database-351-red"
  engine                          = "mysql"
  engine_version                  = "8.0.26"
  instance_class                  = "db.t3.micro"
  allocated_storage               = 10
  storage_type                    = "gp2"
  db_name                         = "red351"
  username                        = "root"
  password                        = random_password.this.result
  multi_az                        = false
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["audit","error","general","slowquery"]
  parameter_group_name            = aws_db_parameter_group.this.id

  tags = {
    Name = "351_db_instance_red"
  }

  depends_on = [aws_db_parameter_group.this]
}

resource "aws_db_parameter_group" "this" {
  name   = "parameter-group-351-red"
  family = "mysql8.0"

  parameter {
    name  = "log_output"
    value = "FILE"
  }
}
