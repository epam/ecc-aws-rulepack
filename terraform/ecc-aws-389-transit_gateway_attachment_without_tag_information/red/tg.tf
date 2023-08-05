resource "aws_ec2_transit_gateway" "this" {}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  subnet_ids         = [aws_subnet.this.id]
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = aws_vpc.this.id
}
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

 resource "aws_subnet" "this" {
   vpc_id     =  aws_vpc.this.id
   cidr_block = "10.0.0.0/24"
 }