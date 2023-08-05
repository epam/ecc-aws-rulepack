# resource creation may take about 30 minutes
resource "aws_fsx_ontap_file_system" "this" {
  storage_capacity                = 1024
  subnet_ids                      = [data.aws_subnets.this.ids[0],data.aws_subnets.this.ids[1]]
  deployment_type                 = "MULTI_AZ_1"
  storage_type                    = "HDD"
  automatic_backup_retention_days = 10
  throughput_capacity             = 128
  preferred_subnet_id             = data.aws_subnets.this.ids[0]

  tags = {
    Name = "466_fsx_ontap_file_system_green"
  }
}