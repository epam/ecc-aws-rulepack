resource "aws_lb" "this" {
  name               = "129albred"
  security_groups    = [aws_security_group.this.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  load_balancer_type = "application"
}

resource "aws_vpc" "this" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "this" {
  name        = "129_security_group_red"
  vpc_id      = aws_vpc.this.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rule1" {
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.this.id
  type      = "ingress"
}

resource "aws_security_group_rule" "rule2" {
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.this.id
  type = "ingress"
}

resource "aws_security_group_rule" "rule3" {
  protocol  = "tcp"
  from_port = 443
  to_port   = 443
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.this.id
  type              = "ingress"
}

resource "aws_security_group_rule" "rule4" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
  "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.this.id
  type              = "egress"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}