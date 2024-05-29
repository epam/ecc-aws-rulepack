output "lightsail" {
  value = {
    lightsail-instance = aws_lightsail_instance.this.arn
  }
}
