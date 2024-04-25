resource "aws_vpc" "this" {
  cidr_block = "192.168.0.0/22"
}

data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_subnet" "subnet_1" {
  availability_zone = data.aws_availability_zones.this.names[0]
  cidr_block        = "192.168.0.0/24"
  vpc_id            = aws_vpc.this.id

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_subnet" "subnet_2" {
  availability_zone = data.aws_availability_zones.this.names[1]
  cidr_block        = "192.168.1.0/24"
  vpc_id            = aws_vpc.this.id

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_subnet" "subnet_3" {
  availability_zone = data.aws_availability_zones.this.names[2]
  cidr_block        = "192.168.2.0/24"
  vpc_id            = aws_vpc.this.id

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_security_group" "this" {
  vpc_id = aws_vpc.this.id

  lifecycle {
    prevent_destroy = false
  }
}
