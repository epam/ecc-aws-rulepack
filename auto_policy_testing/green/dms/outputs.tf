output "dms" {
  value = {
    dms-instance = aws_dms_replication_instance.this.replication_instance_arn
  }
}
