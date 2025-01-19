resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  engine                  = "mysql"
  identifier              = "database-006-red"
  instance_class          = "db.t4g.micro"
  allocated_storage       = 10
  storage_type            = "gp2"
  db_name                 = "database006red"
  username                = "root"
  password                = random_password.this.result
  multi_az                = true
  backup_retention_period = 5
  skip_final_snapshot     = true
}