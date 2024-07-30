resource "aws_instance" "this" {
  ami                    = data.aws_ami.this.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.this1.id}"]
  subnet_id              = data.terraform_remote_state.common.outputs.vpc_subnet_1_id

  tags = {
    Name = "${module.naming.resource_prefix.ec2}"
  }
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
