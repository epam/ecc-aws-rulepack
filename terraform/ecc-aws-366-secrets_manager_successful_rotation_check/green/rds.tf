resource "aws_db_subnet_group" "this" {
  name       = "db-subnet-group-366-green"
  subnet_ids = [aws_subnet.this1.id, aws_subnet.this2.id]
}

resource "aws_db_instance" "this" {
  identifier             = "db-instance-366-green"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  allocated_storage      = 10
  storage_type           = "gp2"
  db_name                = "database366green"
  username               = "adminaccount"
  password               = random_password.this.result
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  publicly_accessible    = true
}

