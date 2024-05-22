output "network" {
  value = {
    network-acl  = aws_network_acl.this.id
    network-addr = aws_eip.this.id
  }
}
