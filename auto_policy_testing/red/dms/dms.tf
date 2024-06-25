# Database Migration Service requires the below IAM Roles to be created before
# replication instances can be created. See the DMS Documentation for
# additional information: https://docs.aws.amazon.com/dms/latest/userguide/security-iam.html
#  * dms-vpc-role
#  * dms-cloudwatch-logs-role
#  * dms-access-for-endpoint

# It takes about 30m to deploy

resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "sleep 10"
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.dms-access-for-endpoint-AmazonDMSRedshiftS3Role,
    aws_iam_role_policy_attachment.dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole,
    aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole,
  ]  
}

resource "aws_dms_replication_instance" "this" {
  provider           = aws.provider2

  allocated_storage          = 5
  engine_version             = "3.5.1"
  apply_immediately          = true
  multi_az                   = false
  publicly_accessible        = true
  replication_instance_class = "dms.t3.micro"
  replication_instance_id    = "${module.naming.resource_prefix.dms}"
  auto_minor_version_upgrade  = false

  depends_on = [
    null_resource.this
  ]

}
