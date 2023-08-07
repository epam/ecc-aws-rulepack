resource "aws_ebs_volume" "this" {
  availability_zone = var.default-az
  size              = 8
}

