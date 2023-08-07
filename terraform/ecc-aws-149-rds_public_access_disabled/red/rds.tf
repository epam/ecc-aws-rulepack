resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  engine              = "mysql"
  engine_version      = "5.7"
  instance_class      = "db.t2.micro"
  allocated_storage   = 10
  storage_type        = "gp2"
  db_name             = "database149red"
  username            = "root"
  publicly_accessible = true
  password            = random_password.this.result
  skip_final_snapshot = true

  tags = {
    Name = "149_db_instance_red"
  }
}