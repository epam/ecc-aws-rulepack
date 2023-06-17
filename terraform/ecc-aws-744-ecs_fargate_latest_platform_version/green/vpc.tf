resource "aws_vpc" "this" {
  cidr_block         = "10.0.0.0/16"
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
  name        = "744_security_group_green"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
}
