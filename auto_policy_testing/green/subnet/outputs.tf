output "subnet" {
  value = {
    subnet = aws_subnet.this.id
  }
}
