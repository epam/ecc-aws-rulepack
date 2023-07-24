resource "aws_instance" "this" {
  ami                         = data.aws_ami.this.id
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  security_groups             = [aws_security_group.group1.id, aws_security_group.group2.id]
  subnet_id                   = aws_subnet.subnet1.id

  tags = {
    Name = "245_ec2_instance_red"
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
  name        = "265_group2_red"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "group1" {
  name        = "265_group1_red"
  vpc_id      = aws_vpc.this.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rule1" {
  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = aws_security_group.group1.id
  type      = "ingress"
}

resource "aws_security_group_rule" "rule2" {
  from_port = 9300
  to_port   = 9300
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = aws_security_group.group1.id
  type      = "ingress"
}

resource "aws_security_group_rule" "rule3" {
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
