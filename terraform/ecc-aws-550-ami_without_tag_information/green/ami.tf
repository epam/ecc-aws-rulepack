resource "aws_ami" "this" {
  name                = "550_ami_green"
  root_device_name    = "/dev/xvda"
  
  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = aws_ebs_snapshot.this.id
    volume_size = 10
  }
}

resource "aws_ebs_volume" "this" {
  availability_zone = "us-east-1a"
  size              = 10
}

resource "aws_ebs_snapshot" "this" {
  volume_id = aws_ebs_volume.this.id
}
