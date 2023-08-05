resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  identifier                      = "database-202-green"
  engine                          = "oracle-ee"
  engine_version                  = "19.0.0.0.ru-2021-04.rur-2021-04.r1"
  instance_class                  = "db.t3.small"
  allocated_storage               = 10
  storage_type                    = "gp2"
  db_name                         = "green202"
  username                        = "root"
  password                        = random_password.this.result
  multi_az                        = false
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["alert", "audit", "listener", "trace"]

  tags = {
    Name = "202_db_instance_green"
  }
}

