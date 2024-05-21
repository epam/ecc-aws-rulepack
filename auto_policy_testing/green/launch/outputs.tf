output "launch" {
  value = {
    launch-config = aws_launch_configuration.this.name
  }
}
