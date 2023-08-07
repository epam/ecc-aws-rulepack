resource "aws_elb" "this" {
  name            = "elb-135-green"
  security_groups = [aws_security_group.group1.id, aws_security_group.group2.id]
  subnets         = [aws_subnet.subnet1.id, aws_subnet.subnet1.id]
  internal        = true

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
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

resource "aws_security_group" "group1" {
  name   = "135_security_group1_green"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
}

resource "aws_security_group" "group2" {
  name   = "135_security_group2_green"
  vpc_id = aws_vpc.this.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rule1" {
  from_port = 7000
  to_port   = 7000
  protocol  = "tcp"
  cidr_blocks = [
    aws_vpc.this.cidr_block
  ]

  security_group_id = aws_security_group.group2.id
  type              = "ingress"
}

resource "aws_security_group_rule" "rule2" {
  from_port = 7199
  to_port   = 7199
  protocol  = "tcp"
  cidr_blocks = [
    aws_vpc.this.cidr_block
  ]

  security_group_id = aws_security_group.group2.id
  type              = "ingress"
}

resource "aws_security_group_rule" "rule3" {
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = aws_security_group.group2.id
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_egress_all" {
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = aws_security_group.group2.id
  type              = "egress"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}
