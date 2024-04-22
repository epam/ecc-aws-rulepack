resource "aws_db_instance" "this" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "rdsgreen"
  username             = "root"
  password             = random_password.this.result
  identifier           = "rds-090-green"
  skip_final_snapshot  = true
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_snapshot" "this" {
  db_instance_identifier = aws_db_instance.this.identifier
  db_snapshot_identifier = "rds-snapshot-090-green"
}