resource "aws_lightsail_instance" "this" {
  name              = "${module.naming.resource_prefix.lightsail_instance}-${random_integer.this.result}"
  availability_zone = data.aws_availability_zones.this.names[0]
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"
  provider          = aws.provider2
  key_pair_name     = aws_lightsail_key_pair.this.name
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_lightsail_key_pair" "this" {
  name       = "${module.naming.resource_prefix.lightsail_instance}"
  public_key = tls_private_key.this.public_key_openssh
}
