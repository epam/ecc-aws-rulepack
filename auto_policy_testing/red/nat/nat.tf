resource "aws_eip" "this" {}

data "aws_availability_zones" "this" {}

# private subnet
resource "aws_nat_gateway" "this" {
  provider      = aws.provider2
  allocation_id = aws_eip.this.id
  subnet_id     = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
}

resource "aws_route_table" "private" {
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
  tags = {
    Name = "${module.naming.resource_prefix.vpc}"
  }
}

resource "aws_subnet" "this" {
  vpc_id            = data.terraform_remote_state.common.outputs.vpc_id
  cidr_block        = "10.0.100.0/24"
  availability_zone = data.aws_availability_zones.this.names[0]

  tags = {
    Name = "${module.naming.resource_prefix.vpc}"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.private.id
}
