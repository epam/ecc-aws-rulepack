output "peering-connection" {
  value = {
    peering-connection = aws_vpc_peering_connection.this.id
  }
}
