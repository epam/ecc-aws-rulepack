# Database Migration Service requires the below IAM Roles to be created before
# replication instances can be created. See the DMS Documentation for
# additional information: https://docs.aws.amazon.com/dms/latest/userguide/security-iam.html
#  * dms-vpc-role
#  * dms-cloudwatch-logs-role
#  * dms-access-for-endpoint

# It takes about 30m to deploy

resource "null_resource" "this" {
  provisioner "local-exec" {
    command     = "sleep 10"
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.dms-access-for-endpoint-AmazonDMSRedshiftS3Role,
    aws_iam_role_policy_attachment.dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole,
    aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole,
  ]
}

resource "aws_dms_replication_subnet_group" "this" {
  replication_subnet_group_description = "${module.naming.resource_prefix.dms}-replication-group"
  replication_subnet_group_id          = "${module.naming.resource_prefix.dms}-replication-group"

  subnet_ids = [
    data.terraform_remote_state.common.outputs.vpc_subnet_1_id,
    data.terraform_remote_state.common.outputs.vpc_subnet_3_id
  ]

  depends_on = [
    aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole
  ]
  lifecycle {
    ignore_changes = [
      replication_subnet_group_id,
      tags
    ]
  }
}

resource "aws_dms_replication_instance" "this" {
  allocated_storage           = 5
  apply_immediately           = true
  multi_az                    = true
  publicly_accessible         = false
  engine_version             = "3.5.3"
  replication_instance_class  = "dms.c5.large"
  replication_instance_id     = module.naming.resource_prefix.dms
  auto_minor_version_upgrade  = true
  replication_subnet_group_id = aws_dms_replication_subnet_group.this.id
  kms_key_arn                 = data.terraform_remote_state.common.outputs.kms_key_arn

  timeouts {
    create = "60m"
  }

  depends_on = [
    null_resource.this
  ]
}

data "aws_availability_zones" "this" {
  state = "available"
}
