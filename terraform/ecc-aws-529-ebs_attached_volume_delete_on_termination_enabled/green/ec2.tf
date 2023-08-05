data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "this" {
  ami               = data.aws_ami.this.id
  instance_type     = "t2.micro"
  availability_zone = aws_subnet.this.availability_zone

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }

  ebs_block_device {
    delete_on_termination = true
    device_name           = "/dev/sdh"
    volume_size           = 1
  }
}
