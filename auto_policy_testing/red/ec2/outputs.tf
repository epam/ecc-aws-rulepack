output "ec2" {
  value = {
    ec2                                                                              = aws_instance.this.id
    ecc-aws-020-instance_without_any_tag                                             = aws_instance.bare.id
    ecc-aws-057-ensure_iam_instance_roles_are_used_for_resource_access_from_instance = aws_instance.bare.id
    ecc-aws-222-ec2_instance_managed_by_systems_manager                              = aws_instance.bare.id
    ecc-aws-223-ec2_managed_instance_association_compliance_status_check             = aws_instance.this.id
  }
}
