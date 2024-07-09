# Instance autotest-ec2-ec2-red-DO-NOT-DELETE-1 with ID i-05ad287ff3ed2b9f5 was created to test policy - ecc-aws-185-ec2_stopped_instance
# Instance autotest-ec2-ec2-red-DO-NOT-DELETE-2 with ID i-03331c1b91e6fffe8 was created to test policy - ecc-aws-610-idle_ec2_instance



resource "aws_instance" "this1" {
  provider      = aws.provider2
  ami           = data.aws_ami.this.id
  instance_type = "t1.micro"
  subnet_id     = data.terraform_remote_state.common.outputs.vpc_subnet_1_id

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 5
  }

  root_block_device {
    delete_on_termination = false
    volume_size           = 8
  }
}

resource "aws_network_interface" "this" {
  subnet_id = data.terraform_remote_state.common.outputs.vpc_subnet_1_id

  attachment {
    instance     = aws_instance.this1.id
    device_index = 1
  }
}

resource "aws_instance" "this2" {
  ami                  = data.aws_ami.this.id
  instance_type        = "t3.micro"
  tenancy              = "dedicated"
  iam_instance_profile = aws_iam_instance_profile.this.name

  tags = {
    Name          = "${module.naming.resource_prefix.ec2}-2"
    "Patch Group" = "${module.naming.resource_prefix.ec2}-patch-group"
  }
}

