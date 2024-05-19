output "nat" {
  value = {
    nat-gateway = aws_nat_gateway.this.id
  }
}
