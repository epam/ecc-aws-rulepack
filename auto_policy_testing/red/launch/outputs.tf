output "launch" {
  value = {
    launch-config = aws_launch_configuration.this.name
    ecc-aws-520-autoscaling_launch_config_hop_limit = aws_launch_configuration.this2.name
  }
}
