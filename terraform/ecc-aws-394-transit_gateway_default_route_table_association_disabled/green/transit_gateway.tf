resource "aws_ec2_transit_gateway" "this" {
  default_route_table_association = "disable"
}