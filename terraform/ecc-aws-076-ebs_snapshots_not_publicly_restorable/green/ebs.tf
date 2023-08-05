resource "aws_ebs_volume" "this" {
  availability_zone = "us-east-1a"
  size              = 10
}

resource "aws_ebs_snapshot" "this" {
  volume_id = aws_ebs_volume.this.id
}