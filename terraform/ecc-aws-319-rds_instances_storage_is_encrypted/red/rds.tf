resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  allocated_storage     = 10
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t3.micro"
  db_name               = "database319red"
  username              = "root"
  password              = random_password.this.result
  parameter_group_name  = "default.mysql5.7"
  skip_final_snapshot   = true

  tags = {
    Name = "319_db_instance_red"
  }
}