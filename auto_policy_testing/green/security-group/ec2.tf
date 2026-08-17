resource "aws_network_interface" "this" {
  subnet_id       = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
  security_groups = [aws_security_group.this.id]

  tags = {
    Name = "${module.naming.resource_prefix.security_group}-eni"
  }

  depends_on = [aws_vpc_security_group_egress_rule.egress_port_0]
}

# Attach SG to an ENI so ecc-aws-070 unused filter does not match (green).
resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }

  tags = {
    Name = "${module.naming.resource_prefix.ec2_instance}"
  }
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
