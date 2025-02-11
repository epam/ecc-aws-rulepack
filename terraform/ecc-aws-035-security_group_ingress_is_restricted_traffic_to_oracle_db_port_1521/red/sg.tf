data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "035_security_group_red"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "035_security_group_red"
  }

  ingress {
    from_port   = 1521
    to_port     = 2483
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
}