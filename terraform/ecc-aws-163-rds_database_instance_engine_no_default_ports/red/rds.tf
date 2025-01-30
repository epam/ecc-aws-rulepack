resource "random_password" "this" {
  length           = 12
  lower            = true
  min_lower        = 1
  upper            = true
  min_upper        = 1
  special          = true
  min_special      = 1
  numeric          = true
  min_numeric      = 1
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  identifier               = "database-163-red"
  allocated_storage        = 10
  engine                   = "mysql"
  instance_class           = "db.t3.micro"
  db_name                  = "database163green"
  username                 = "root"
  password                 = random_password.this.result
  skip_final_snapshot      = true
  engine_lifecycle_support = "open-source-rds-extended-support-disabled"
}
