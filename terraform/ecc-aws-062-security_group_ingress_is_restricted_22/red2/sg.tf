data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "062_security_group_red2"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "062_security_group_red2"
  }

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