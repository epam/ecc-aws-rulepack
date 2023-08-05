resource "aws_ebs_volume" "this" {
  size              = 1
  availability_zone = aws_instance.this.availability_zone
}

resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = aws_instance.this.id
}
