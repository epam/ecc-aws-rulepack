resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = aws_instance.this.id
}
resource "aws_instance" "this" {
  ami               = data.aws_ami.this.id
  instance_type     = "t2.nano"
  availability_zone = "us-east-1a"
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_ebs_volume" "this" {
  availability_zone = "us-east-1a"
  size              = 1
}