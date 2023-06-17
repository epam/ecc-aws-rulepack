resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.this.id

  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.this.id

  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "this" {
  name   = "374_security_group_green"
  vpc_id = aws_vpc.this.id

  dynamic "ingress" {
    for_each = [443, 10250]
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      self      = true

    }
  }


  dynamic "egress" {
    for_each = [443, 10250]
    content {
      from_port = egress.value
      to_port   = egress.value
      protocol  = "tcp"
      self      = true

    }
  }

}