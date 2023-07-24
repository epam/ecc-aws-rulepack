resource "aws_db_instance" "this" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_name                = "database303green1"
  username               = "root"
  password               = random_password.this.result
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.this.id]
  identifier             = "rds-instance-303-green1"

  tags = {
    Name  = "303_instance_green1"
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}