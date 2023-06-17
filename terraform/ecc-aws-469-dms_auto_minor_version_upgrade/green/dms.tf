resource "aws_dms_replication_instance" "this" {
  allocated_storage            = 5
  apply_immediately            = true
  publicly_accessible          = false
  replication_instance_class   = "dms.t2.micro"
  replication_instance_id      = "dms-replication-instance-469-green"
  engine_version               = "3.4.6"
   auto_minor_version_upgrade  = true
  depends_on = [
    null_resource.this
  ]
}
