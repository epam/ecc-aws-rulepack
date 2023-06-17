resource "aws_lb" "this" {
  name                   = "alb-696-red"
  load_balancer_type     = "application"
  security_groups        = [aws_security_group.group1.id]
  subnets                = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  internal               = false
  desync_mitigation_mode = "monitor"
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
  name   = "696_security_group1_red"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 8140
    to_port     = 8140
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}
