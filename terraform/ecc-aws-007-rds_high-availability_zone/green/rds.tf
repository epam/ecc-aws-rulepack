resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  allocated_storage       = 10
  storage_type            = "gp2"
  db_name                 = "database007green"
  username                = "root"
  password                = random_password.this.result
  multi_az                = true
  skip_final_snapshot     = true
}