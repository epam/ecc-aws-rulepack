resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${module.naming.resource_prefix.vpc}"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone_id    = "use1-az2"
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.this.names[0]
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "subnet3" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.3.0/24"
  availability_zone_id    = "use1-az4"
  map_public_ip_on_launch = "true"
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
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "this2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "this3" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.this.id
}
