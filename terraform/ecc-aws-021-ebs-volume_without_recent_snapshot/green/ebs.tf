resource "aws_ebs_volume" "this" {
  availability_zone = var.default-az
  size              = 8

  tags = {
    Name = "021_ebs_volume_green"
  }
}

resource "aws_ebs_snapshot" "this" {
  volume_id = aws_ebs_volume.this.id

  tags = {
    Name = "021_ebs_snapshot_green"
  }
}
