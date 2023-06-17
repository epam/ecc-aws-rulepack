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
  name   = "508_security_group_green"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 8162
    to_port     = 8162
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
  ingress {
    from_port   = 61617
    to_port     = 61617
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}