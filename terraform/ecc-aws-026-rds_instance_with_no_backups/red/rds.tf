resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  allocated_storage    = 20
  identifier           = "database-026-green"
  storage_type         = "gp2"
  engine               = "mysql"
  instance_class       = "db.t4g.micro"
  db_name              = "rds026red"
  username             = "root"
  password             = random_password.this.result
  storage_encrypted           = true
  backup_retention_period = "0"
  skip_final_snapshot = true
}