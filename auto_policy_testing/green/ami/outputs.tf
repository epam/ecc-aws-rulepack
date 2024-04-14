output "ami" {
  value = {
    ami                            = aws_ami.this.id
    ecc-aws-630-ec2_ami_not_in_use = aws_ami_from_instance.this.id
  }
}
