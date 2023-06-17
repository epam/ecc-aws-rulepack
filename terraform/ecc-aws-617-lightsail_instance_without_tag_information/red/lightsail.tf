resource "aws_lightsail_instance" "this" {
  name              = "lightsail-instance-617-red"
  availability_zone = "us-east-1b"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"
  key_pair_name     = aws_lightsail_key_pair.this.name
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_lightsail_key_pair" "this" {
  name       = "key-pair-617-red"
  public_key = tls_private_key.this.public_key_openssh
}
