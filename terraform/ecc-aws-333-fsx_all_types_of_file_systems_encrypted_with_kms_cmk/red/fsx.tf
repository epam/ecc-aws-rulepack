resource "aws_fsx_ontap_file_system" "this" {
  storage_capacity                = 1024
  subnet_ids                      = [aws_subnet.this1.id, aws_subnet.this2.id]
  deployment_type                 = "MULTI_AZ_1"
  throughput_capacity             = 512
  preferred_subnet_id             = aws_subnet.this1.id
  automatic_backup_retention_days = 0
  
  tags = {
    Name = "333_fsx_ontap_file_system_red"
  }
}
