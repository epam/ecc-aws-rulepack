output "eni" {
  value = {
    eni = aws_network_interface.this.id
  }
}
