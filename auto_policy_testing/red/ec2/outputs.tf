output "ec2" {
  value = {
    ec2                                                                  = aws_instance.this1.id
    ecc-aws-185-ec2_stopped_instance                                     = "i-05ad287ff3ed2b9f5"
    ecc-aws-091-ec2_managed_ssm_patch_compliance                         = aws_instance.this2.id
    ecc-aws-223-ec2_managed_instance_association_compliance_status_check = aws_instance.this2.id
    ecc-aws-576-ec2_instance_dedicated_tenancy                           = aws_instance.this2.id
    ecc-aws-610-idle_ec2_instance                                        = "i-03331c1b91e6fffe8"
    ecc-aws-131-instance_with_unencrypted_service_is_exposed_to_public_internet = [aws_instance.this1.id, aws_instance.this3.id]
    ecc-aws-132-public_instance_with_sensitive_service_is_exposed_to_entire_internet = [aws_instance.this1.id, aws_instance.this3.id]
  }
}
