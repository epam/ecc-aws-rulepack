data "aws_vpc" "this" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "305_security_group_red1"
  vpc_id = data.aws_vpc.this.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "default" {
  identifier             = "database-305-red1"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_name                = "database305red1"
  username               = "root"
  port                   = 3306
  password               = random_password.this.result
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = ["${aws_security_group.this.id}"]

  tags = {
    Name = "305_db_instance_red1"
  }
}
