resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

}

resource "aws_subnet" "this1" {
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}
resource "aws_subnet" "this2" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

}
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this1.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "this2" {
  subnet_id      = aws_subnet.this2.id
  route_table_id = aws_route_table.this.id
}

resource "aws_security_group" "this" {
  name   = "366_security_group_green"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "this" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.us-east-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [aws_subnet.this1.id, aws_subnet.this2.id]
  security_group_ids = [
    aws_security_group.this.id,
  ]

}
