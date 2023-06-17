resource "aws_emr_cluster" "this" {
  name                              = "343_emr_cluster_green"
  release_label                     = "emr-5.33.0"
  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true
  ec2_attributes {
    subnet_id                         = aws_subnet.private.id
    emr_managed_master_security_group = aws_security_group.master_security_group.id
    emr_managed_slave_security_group  = aws_security_group.slave_security_group.id
    instance_profile                  = aws_iam_instance_profile.this.arn
    service_access_security_group     = aws_security_group.service_access_security_group.id
  }

  master_instance_group {
    name           = "343_master_instance_group_green"
    instance_type  = "m4.large"
    instance_count = 1
  }

  core_instance_group {
    name           = "343_core_instance_group_green"
    instance_count = 1
    instance_type  = "m4.large"
  }

  service_role = aws_iam_role.emr_service_role.arn

  depends_on = [aws_subnet.private, aws_iam_role.emr_service_role, aws_iam_role.emr_ec2_instance_profile, aws_iam_instance_profile.this, aws_nat_gateway.this]
}
