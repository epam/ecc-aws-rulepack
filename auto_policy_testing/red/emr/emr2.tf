# time to deploy is about 10 min

resource "aws_emr_cluster" "this2" {
  name                              = "${module.naming.resource_prefix.emr}-2"
  release_label                     = "emr-7.1.0"
  applications                      = ["Spark"]
  ebs_root_volume_size              = 15
  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true

  ec2_attributes {
    subnet_id                         = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
    emr_managed_master_security_group = aws_security_group.this.id
    emr_managed_slave_security_group  = aws_security_group.this.id
    instance_profile                  = aws_iam_instance_profile.this.arn
  }

  master_instance_group {
    name           = "${module.naming.resource_prefix.ec2_instance}-master"
    instance_type  = "m4.large"
    instance_count = 1
  }

  core_instance_group {
    name           = "${module.naming.resource_prefix.ec2_instance}-core"
    instance_count = 1
    instance_type  = "m4.large"
  }

  service_role = aws_iam_role.emr_service_role.arn

  tags = {
    for-use-with-amazon-emr-managed-policies = true
  }

  depends_on = [aws_iam_role.emr_service_role, aws_iam_role.emr_ec2_instance_profile, aws_iam_instance_profile.this]
}


resource "null_resource" "this1" {
  triggers = {
    emr = aws_emr_cluster.this1.id
  }
  provisioner "local-exec" {
    command = "aws emr remove-tags --resource-id ${self.triggers.emr} --tag-keys 'for-use-with-amazon-emr-managed-policies'"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "aws emr add-tags --resource-id ${self.triggers.emr} --tags 'for-use-with-amazon-emr-managed-policies'=true"
  }

  depends_on = [aws_emr_cluster.this1]
}