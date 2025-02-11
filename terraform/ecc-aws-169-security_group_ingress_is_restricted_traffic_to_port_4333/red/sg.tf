data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "166_security_group_red"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "166_security_group_red"
  }

  ingress {
    from_port   = 100
    to_port     = 10000
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
