resource "aws_ebs_volume" "this" {
  availability_zone = "us-east-1a"
  size              = 8
}

resource "aws_ebs_snapshot" "this" {
  volume_id = aws_ebs_volume.this.id
}

resource "aws_ebs_encryption_by_default" "this" {
  enabled = false
}
