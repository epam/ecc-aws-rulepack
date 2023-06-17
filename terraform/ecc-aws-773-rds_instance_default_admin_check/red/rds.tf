resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  allocated_storage     = 10
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t3.micro"
  db_name               = "database773red"
  username              = "admin"
  password              = random_password.this.result
  parameter_group_name  = "default.mysql5.7"
  skip_final_snapshot   = true
}
