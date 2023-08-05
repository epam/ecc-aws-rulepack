resource "aws_ami" "this" {
  name                = "377_ami_red"
  root_device_name    = "/dev/xvda"
  
  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = aws_ebs_snapshot.this.id
    volume_size = 8
  }
}

resource "aws_ebs_volume" "this" {
  availability_zone = "us-east-1a"
  size              = 8
}

resource "aws_ebs_snapshot" "this" {
  volume_id = aws_ebs_volume.this.id
}
