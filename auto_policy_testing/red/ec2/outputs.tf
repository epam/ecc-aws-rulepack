output "ec2" {
  value = {
    ec2 = aws_instance.this.id
  }
}
