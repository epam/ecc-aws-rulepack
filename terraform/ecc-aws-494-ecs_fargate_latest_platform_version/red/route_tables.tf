resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "table1" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table" "table2" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "association1" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.table1.id
}

resource "aws_route_table_association" "association2" {
  subnet_id = aws_subnet.subnet2.id
  route_table_id = aws_route_table.table2.id
}