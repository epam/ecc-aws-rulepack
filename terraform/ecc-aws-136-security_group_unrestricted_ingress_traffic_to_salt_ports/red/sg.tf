data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "136_security_group_red"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "136_security_group_red"
  }

  ingress {
    from_port   = 4506
    to_port     = 4510
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
