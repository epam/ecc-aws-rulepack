resource "aws_fsx_lustre_file_system" "this" {
  storage_capacity                = 6000
  subnet_ids                      = [data.aws_subnets.this.ids[0]]
  deployment_type                 = "PERSISTENT_1"
  storage_type                    = "HDD"
  drive_cache_type                = "NONE"
  per_unit_storage_throughput     = 12
  automatic_backup_retention_days = 10
  data_compression_type           = "LZ4"

  tags = {
    Name = "691_fsx_lustre_file_system_green"
  }
}

resource "aws_fsx_openzfs_file_system" "this" {
  storage_capacity                = 64
  subnet_ids                      = [data.aws_subnets.this.ids[0]]
  deployment_type                 = "SINGLE_AZ_1"
  throughput_capacity             = 64
  automatic_backup_retention_days = 10

  tags = {
    Name = "691_fsx_openzfs_file_system_green"
  }
}
