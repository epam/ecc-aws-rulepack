resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}
resource "aws_db_instance" "this" {
  engine              = "mysql"
  engine_version      = "5.7"
  instance_class      = "db.t2.micro"
  allocated_storage   = 10
  storage_type        = "gp2"
  db_name             = "database428green"
  username            = "root"
  password            = random_password.this.result
  skip_final_snapshot = true
  tags = {
    Name = "428_db_instance_green"
  }
}

resource "aws_db_snapshot" "this" {
  db_instance_identifier = aws_db_instance.this.id
  db_snapshot_identifier = "db428snapshopgreen"
}
