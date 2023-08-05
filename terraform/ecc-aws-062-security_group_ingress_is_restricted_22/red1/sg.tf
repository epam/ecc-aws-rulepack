resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "this" {
  name   = "062_security_group_red1"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
