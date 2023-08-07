resource "aws_dms_replication_subnet_group" "this" {
  replication_subnet_group_description = "325_subnet_group_green"
  replication_subnet_group_id          = "subnet-group-green"
  

  subnet_ids = [
    aws_subnet.subnet1.id,
    aws_subnet.subnet2.id
  ]
  
  depends_on = [
     aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole
  ]
    lifecycle {
    ignore_changes = [
    replication_subnet_group_id,
    tags,
    ]
  }
}

resource "aws_dms_replication_instance" "this" {
  allocated_storage            = 5
  apply_immediately            = true
  multi_az                     = true
  publicly_accessible          = false
  replication_instance_class   = "dms.t2.micro"
  replication_instance_id      = "dms-replication-instance-325-green"
  replication_subnet_group_id  = aws_dms_replication_subnet_group.this.id
  depends_on = [
    null_resource.this,
    aws_dms_replication_subnet_group.this
  ]
}
