resource "aws_security_group" "this" {
  name                   = "${module.naming.resource_prefix.security_group}"
  vpc_id                 = data.terraform_remote_state.common.outputs.vpc_id
  revoke_rules_on_delete = true
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "udp"
    self      = true
  }
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }
  ingress {
    from_port = "-1"
    to_port   = "-1"
    protocol  = "icmp"
    self      = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    for-use-with-amazon-emr-managed-policies = true
  }
}
