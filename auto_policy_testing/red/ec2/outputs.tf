output "ec2" {
  value = {
    ec2 = aws_instance.this1.id
    ecc-aws-091-ec2_managed_ssm_patch_compliance = aws_instance.this2.id
    ecc-aws-576-ec2_instance_dedicated_tenancy = aws_instance.this2.id
  }
}
