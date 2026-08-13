resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Tagged (default_tags) + attached to instance: green for 329 and 533
resource "aws_key_pair" "this" {
  key_name   = "${module.naming.resource_prefix.kms_key}-keypair"
  public_key = tls_private_key.this.public_key_openssh
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.this.key_name

  tags = {
    Name = "${module.naming.resource_prefix.kms_key}-instance"
  }
}
