resource "aws_instance" "this" {
  ami                         = data.aws_ami.this.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.group1.id, aws_security_group.group2.id]
  subnet_id                   = aws_subnet.subnet1.id

  tags = {
    Name = "132_ec2_instance_green"
  }
}

data "aws_ami" "this" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
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

resource "aws_security_group" "group2" {
  name        = "132_security_group2_green"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 4505
    to_port     = 4505
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
}

resource "aws_security_group" "group1" {
  name        = "132_security_group1_green"
  vpc_id      = aws_vpc.this.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rule1" {
  from_port = 8000
  to_port   = 8000
  protocol  = "tcp"
  cidr_blocks = [
    aws_vpc.this.cidr_block
  ]

  security_group_id = aws_security_group.group1.id
  type      = "ingress"
}

resource "aws_security_group_rule" "rule2" {
  from_port = 5500
  to_port   = 5500
  protocol  = "tcp"
  cidr_blocks = [
    aws_vpc.this.cidr_block
  ]

  security_group_id = aws_security_group.group1.id
  type      = "ingress"
}

resource "aws_security_group_rule" "rule3" {
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = aws_security_group.group1.id
  type      = "ingress"
}

resource "aws_security_group_rule" "rule4" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
  "0.0.0.0/0"]
  security_group_id = aws_security_group.group1.id
  type              = "egress"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}
