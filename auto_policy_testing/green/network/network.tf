resource "aws_network_acl" "this" {
  vpc_id     = data.terraform_remote_state.common.outputs.vpc_id
  subnet_ids = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id]
  tags = {
    Name = "${module.naming.resource_prefix.nacl}"
  }
}

resource "aws_eip" "this" {
  instance = aws_instance.this.id
  tags = {
    Name = "${module.naming.resource_prefix.eip}"
  }
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = "t2.micro"
  tags = {
    Name = "${module.naming.resource_prefix.ec2_instance}"
  }
}
