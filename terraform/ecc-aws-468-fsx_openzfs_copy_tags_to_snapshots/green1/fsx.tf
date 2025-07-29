# Deployment time: 5 min
# Destroy: 10 min

resource "aws_fsx_openzfs_file_system" "this" {
  storage_capacity                = 64
  subnet_ids                      = [data.aws_subnets.this.ids[0]]
  deployment_type                 = "SINGLE_AZ_1"
  throughput_capacity             = 64
  automatic_backup_retention_days = 0
  skip_final_backup               = true

  root_volume_configuration {
    copy_tags_to_snapshots = true
    data_compression_type = "LZ4"
  }

  tags = {
    Name = "468_fsx_openzfs_file_system_green1"
  }
}

resource "aws_fsx_openzfs_volume" "this" {
  name             = "468_fsx_openzfs_volume_green"
  parent_volume_id = aws_fsx_openzfs_file_system.this.root_volume_id
  copy_tags_to_snapshots = true
  data_compression_type = "NONE"
  
}