resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# doc why only specific AZ ids are supported: https://docs.aws.amazon.com/workspaces/latest/adminguide/azs-workspaces.html

resource "aws_subnet" "this1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone_id    = local.aws_region_az_ids[var.default-region].azs[0]
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "this2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.2.0/24"
  availability_zone_id    = local.aws_region_az_ids[var.default-region].azs[1]
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "this3" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.3.0/24"
  availability_zone_id    = local.aws_region_az_ids[var.default-region].azs[2]
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
  subnet_id      = aws_subnet.this1.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "this2" {
  subnet_id      = aws_subnet.this2.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "this3" {
  subnet_id      = aws_subnet.this3.id
  route_table_id = aws_route_table.this.id
}


resource "aws_vpc_endpoint" "this" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.default-region}.workspaces"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = false
  subnet_ids          = [aws_subnet.this1.id, aws_subnet.this2.id]
}

resource "aws_vpc_endpoint" "this2" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.default-region}.workspaces"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = false
  subnet_ids          = [aws_subnet.this3.id]
}

data "aws_availability_zones" "this" {
  state = "available"
}
data "aws_vpc_endpoint_service" "this" {
  service_name = "com.amazonaws.${var.default-region}.workspaces"
}
