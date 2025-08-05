resource "aws_db_instance" "this" {
  identifier           = "instance-161-green"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.4"
  instance_class       = "db.t3.micro"
  username             = "root"
  password             = random_password.this.result
  skip_final_snapshot  = true

  tags = {
    Name = "161_db_instance_green"
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}