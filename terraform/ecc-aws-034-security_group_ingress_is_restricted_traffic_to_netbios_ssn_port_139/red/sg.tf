data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "034_security_group_red"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "034_security_group_red"
  }

  ingress {
    from_port   = 130
    to_port     = 137
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
}