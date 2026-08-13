resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Untagged + unused: satisfies ecc-aws-329 and ecc-aws-533
resource "aws_key_pair" "this" {
  key_name   = "${module.naming.resource_prefix.kms_key}-keypair"
  public_key = tls_private_key.this.public_key_openssh
  provider   = aws.provider2
}
