resource "aws_emr_cluster" "this" {
  name                              = "456_emr_cluster_green"
  release_label                     = "emr-5.33.0"
  applications                      = ["Spark"]
  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true
  ebs_root_volume_size              = 10
  security_configuration            = aws_emr_security_configuration.this.name

  ec2_attributes {
    subnet_id                         = aws_subnet.this.id
    emr_managed_master_security_group = aws_security_group.this.id
    emr_managed_slave_security_group  = aws_security_group.this.id
    instance_profile                  = aws_iam_instance_profile.this.arn
  }

  master_instance_group {
    name           = "456_master_instance_group_green"
    instance_type  = "m4.large"
    instance_count = 1
  }

  core_instance_group {
    name           = "456_core_instance_group_green"
    instance_count = 1
    instance_type  = "m4.large"
  }

  service_role = aws_iam_role.emr_service_role.arn

  depends_on = [aws_subnet.this, aws_iam_role.emr_service_role, aws_iam_role.emr_ec2_instance_profile, aws_iam_instance_profile.this]
}

resource "aws_emr_security_configuration" "this" {
  name = "456_security_configuration_green"
  configuration = <<EOF
{
  "InstanceMetadataServiceConfiguration" : {
      "MinimumInstanceMetadataServiceVersion": 2,
      "HttpPutResponseHopLimit": 1
   }
}
EOF
}