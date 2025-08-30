resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_subnet" "this1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.this.names[0]
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "this2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.this.names[1]
  map_public_ip_on_launch = "true"
}

data "aws_security_group" "default" {
  name = "default"
  vpc_id = aws_vpc.this.id

  depends_on = [ aws_vpc.this ]
}

resource "aws_security_group" "this" {
  name   = "292_security_group_green"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

resource "aws_route_table_association" "this1" {
  subnet_id      = aws_subnet.this1.id
  route_table_id = aws_route_table.this.id
}
resource "aws_route_table_association" "this2" {
  subnet_id      = aws_subnet.this2.id
  route_table_id = aws_route_table.this.id
}