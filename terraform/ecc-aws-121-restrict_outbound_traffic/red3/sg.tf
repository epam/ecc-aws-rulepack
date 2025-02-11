data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "121_security_group_red3"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "121_security_group_red3"
  }
  
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
