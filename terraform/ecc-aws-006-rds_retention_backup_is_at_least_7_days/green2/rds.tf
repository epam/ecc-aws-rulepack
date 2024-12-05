resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  allocated_storage       = 20
  identifier              = "database-006-green2"
  instance_class          = "db.t4g.micro"
  storage_type            = "gp2"
  engine                  = "mysql"
  db_name                 = "rds006green"
  username                = "root"
  password                = random_password.this.result
  storage_encrypted       = true
  backup_retention_period = "0"
  skip_final_snapshot     = true
}