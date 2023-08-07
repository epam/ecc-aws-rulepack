resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  identifier                      = "database-206-red"
  engine                          = "sqlserver-web"
  engine_version                  = "15.00.4073.23.v1"
  instance_class                  = "db.t3.small"
  allocated_storage               = 20
  license_model                   = "license-included"
  storage_type                    = "gp2"
  username                        = "root"
  password                        = random_password.this.result
  multi_az                        = false
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["agent"]

  tags = {
    Name = "352_db_instance_red"
  }
}