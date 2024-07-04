output "ec2" {
  value = {
    ec2 = aws_instance.this1.id
    ecc-aws-186-ec2_instance_no_public_ip = aws_instance.this2.id
  }
}
