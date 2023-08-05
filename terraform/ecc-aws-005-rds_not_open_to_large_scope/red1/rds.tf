resource "aws_security_group" "this" {
  name        = "005_security_group_red1"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  identifier           = "database-005-red1"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  allocated_storage    = 20
  db_name              = "database005red1"
  storage_type         = "gp2"
  username             = "root"
  password             = random_password.this.result
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = ["${aws_security_group.this.id}"]
}