# ecc-aws-092-ami_public_access
# ecc-aws-377-ami_without_tag_information
resource "aws_ebs_volume" "this" {
  availability_zone = data.aws_availability_zones.this.names[0]
  size              = 10
  tags = {
    Name = "${module.naming.resource_prefix.ebs_volume}"
  }
}

resource "aws_ebs_snapshot" "this" {
  volume_id = aws_ebs_volume.this.id
  tags = {
    Name = "${module.naming.resource_prefix.ebs_snapshot}"
  }
}

resource "aws_ami" "this" {
  name             = module.naming.resource_prefix.ami
  root_device_name = "/dev/xvda"

  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = aws_ebs_snapshot.this.id
    volume_size = 10
  }
}

# ecc-aws-630-ec2_ami_not_in_use
resource "aws_instance" "ami" {
  ami           = data.aws_ami.ami.id
  instance_type = "t2.micro"

  tags = {
    Name = "${module.naming.resource_prefix.ami}"
  }
}

resource "aws_ami_from_instance" "this" {
  name               = "${module.naming.resource_prefix.ami}_from_instance"
  source_instance_id = aws_instance.ami.id
}


resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = "t2.micro"

  tags = {
    Name = "${module.naming.resource_prefix.ami}"
  }
}
