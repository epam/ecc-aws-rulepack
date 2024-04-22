resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "rds026green"
  username             = "root"
  password             = random_password.this.result
  parameter_group_name = "default.mysql5.7"
  backup_retention_period = "2"
  skip_final_snapshot = true
}