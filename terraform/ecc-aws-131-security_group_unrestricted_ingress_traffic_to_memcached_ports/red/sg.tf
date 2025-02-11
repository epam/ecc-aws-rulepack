data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "131_security_group_red"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "131_security_group_red"
  }

  ingress {
    from_port   = 11210
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
