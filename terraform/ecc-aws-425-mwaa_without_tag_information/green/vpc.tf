resource "aws_vpc" "this" {
  cidr_block         = "10.0.0.0/16"
  enable_dns_support = true

  tags = {
    Name = "425_vpc_green"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_subnet" "public1" {
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.this.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public2" {
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.this.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
}

resource "aws_eip" "this1" {
  vpc        = true
  depends_on = [aws_internet_gateway.this]
}
resource "aws_eip" "this2" {
  vpc        = true
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this1" {
  allocation_id = aws_eip.this1.id
  subnet_id     = aws_subnet.public1.id
  depends_on    = [aws_eip.this1]
}

resource "aws_nat_gateway" "this2" {
  allocation_id = aws_eip.this2.id
  subnet_id     = aws_subnet.public2.id
  depends_on    = [aws_eip.this2]
}

resource "aws_security_group" "this" {
  name                   = "787_security_group_green"
  vpc_id                 = aws_vpc.this.id
  revoke_rules_on_delete = true
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "route_table_internet_gateway" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  depends_on = [
    aws_vpc.this,
    aws_internet_gateway.this
  ]
}

resource "aws_route_table_association" "route_table_internet_gateway1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.route_table_internet_gateway.id
}

resource "aws_route_table_association" "route_table_internet_gateway2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.route_table_internet_gateway.id
}

resource "aws_route_table" "route_table_nat_gateway1" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this1.id
  }

  depends_on = [
    aws_vpc.this,
    aws_nat_gateway.this1
  ]
}

resource "aws_route_table" "route_table_nat_gateway2" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this2.id
  }

  depends_on = [
    aws_vpc.this,
    aws_nat_gateway.this2
  ]
}

resource "aws_route_table_association" "route_table_nat_gateway1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.route_table_nat_gateway1.id
}

resource "aws_route_table_association" "route_table_nat_gateway2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.route_table_nat_gateway2.id
}