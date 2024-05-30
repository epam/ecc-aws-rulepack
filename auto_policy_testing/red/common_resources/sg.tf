resource "aws_security_group" "this" {
  name   = module.naming.resource_prefix.security_group
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${module.naming.resource_prefix.security_group}"
  }
}

