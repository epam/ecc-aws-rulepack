resource "aws_ebs_volume" "this" {
  availability_zone = data.aws_availability_zones.this.names[0]
  size              = 8
  type              = "gp3"
}

data "aws_availability_zones" "this" {
  state = "available"
}