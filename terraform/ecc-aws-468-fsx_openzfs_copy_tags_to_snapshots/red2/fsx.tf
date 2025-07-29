# Deployment time: 5 min
# Destroy: 10 min

resource "aws_fsx_openzfs_file_system" "this" {
  storage_capacity                = 64
  subnet_ids                      = [data.aws_subnets.this.ids[0]]
  deployment_type                 = "SINGLE_AZ_1"
  throughput_capacity             = 64
  automatic_backup_retention_days = 0
  skip_final_backup               = true
  delete_options = ["DELETE_CHILD_VOLUMES_AND_SNAPSHOTS"]
  
  root_volume_configuration {
    copy_tags_to_snapshots = false
    data_compression_type = "LZ4"
  }

  tags = {
    Name = "468_fsx_openzfs_file_system_red2"
  }
}
