resource "aws_ebs_volume" "this" {
  availability_zone = var.default-az
  size              = 8

  tags = {
    Name = "021_ebs_volume_red"
  }
}

