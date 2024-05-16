resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
  provider      = aws.provider2
}

resource "aws_internet_gateway" "this" {
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
}

resource "aws_route_table" "public" {
  vpc_id   = data.terraform_remote_state.common.outputs.vpc_id
  provider = aws.provider2

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "this" { }

resource "aws_route_table" "private" {
  vpc_id   = data.terraform_remote_state.common.outputs.vpc_id
  provider = aws.provider2

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = data.terraform_remote_state.common.outputs.vpc_subnet_2_id
  route_table_id = aws_route_table.private.id
}
