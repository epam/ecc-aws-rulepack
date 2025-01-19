resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  engine                  = "mysql"
  identifier              = "database-006-green"
  instance_class          = "db.t4g.micro"
  allocated_storage       = 10
  storage_type            = "gp2"
  db_name                 = "database006green"
  username                = "root"
  password                = random_password.this.result
  multi_az                = true
  backup_retention_period = 7
  skip_final_snapshot     = true
}


resource "aws_db_instance" "this-replica" {
  replicate_source_db     = aws_db_instance.this.identifier
  identifier              = "database-006-green-replica"
  instance_class          = "db.t4g.micro"
  storage_type            = "gp2"
  storage_encrypted       = true
  backup_retention_period = "2"
  skip_final_snapshot     = true
}