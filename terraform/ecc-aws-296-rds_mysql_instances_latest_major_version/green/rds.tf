resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  allocated_storage     = 10
  engine                = "mysql"
  engine_version        = "8.0.27"
  instance_class        = "db.t3.micro"
  db_name               = "database296green"
  username              = "root"
  password              = random_password.this.result
  parameter_group_name  = "default.mysql8.0"
  skip_final_snapshot   = true
}
