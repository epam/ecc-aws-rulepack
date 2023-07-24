resource "aws_ebs_volume" "this" {
  availability_zone = var.default-az
  size              = 8

  tags = {
    Name = "100_ebs_volume_Green"
  }
}

resource "aws_ebs_snapshot" "this" {
  volume_id = aws_ebs_volume.this.id
}
