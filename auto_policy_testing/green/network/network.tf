resource "aws_network_acl" "this" {
  vpc_id     = data.terraform_remote_state.common.outputs.vpc_id
  subnet_ids = [data.terraform_remote_state.common.outputs.vpc_subnet_private_1_id]

  ingress {
    protocol   = "tcp"
    rule_no    = 1
    action     = "allow"
    cidr_block = "10.0.0.0/24"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 2
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 10
    to_port    = 15
  }

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
