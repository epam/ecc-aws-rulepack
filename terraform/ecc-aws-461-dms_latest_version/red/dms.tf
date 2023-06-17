resource "aws_dms_replication_instance" "this" {
  allocated_storage          = 5
  apply_immediately          = true
  availability_zone          = "us-east-1c"
  publicly_accessible        = false
  engine_version             = "3.4.2"
  replication_instance_class = "dms.t2.micro"
  replication_instance_id    = "dms-replication-instance-461-red"

  depends_on = [
    null_resource.this
  ]

}
