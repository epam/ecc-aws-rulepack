resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${module.naming.resource_prefix.vpc}"
  }
}

data "aws_availability_zone" "public1" {
  zone_id = "use1-az2"
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone_id    = data.aws_availability_zone.public1.zone_id
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${module.naming.resource_prefix.general}-public-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.this.names[0]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${module.naming.resource_prefix.general}-public-2"
  }
}

data "aws_availability_zone" "public3" {
  zone_id = "use1-az4"
}

resource "aws_subnet" "public3" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.3.0/24"
  availability_zone_id    = data.aws_availability_zone.public3.zone_id
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${module.naming.resource_prefix.general}-public-3"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = data.aws_availability_zones.this.names[0]
  tags = {
    Name = "${module.naming.resource_prefix.general}-private-1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = data.aws_availability_zones.this.names[1]
  tags = {
    Name = "${module.naming.resource_prefix.general}-private-2"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${module.naming.resource_prefix.vpn_gtw}"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${module.naming.resource_prefix.vpn_gtw}-internet"
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "this2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "this3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.this.id
}

# resource "aws_eip" "this" {
#   domain     = "vpc"
#   depends_on = [aws_internet_gateway.this]
#   tags = {
#     Name = "${module.naming.resource_prefix.eip}"
#   }
# }

# resource "aws_nat_gateway" "this" {
#   allocation_id = aws_eip.this.id
#   subnet_id     = aws_subnet.public1.id
#   depends_on    = [aws_eip.this]
#   tags = {
#     Name = "${module.naming.resource_prefix.vpn_gtw}"
#   }
# }

# resource "aws_route_table" "route_table_nat_gateway" {
#   vpc_id = aws_vpc.this.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.this.id
#   }
#   tags = {
#     Name = "${module.naming.resource_prefix.vpn_gtw}-nat"
#   }
# }

# resource "aws_route_table_association" "route_table_nat_gateway1" {
#   subnet_id      = aws_subnet.private1.id
#   route_table_id = aws_route_table.route_table_nat_gateway.id
# }

# resource "aws_route_table_association" "route_table_nat_gateway2" {
#   subnet_id      = aws_subnet.private2.id
#   route_table_id = aws_route_table.route_table_nat_gateway.id
# }