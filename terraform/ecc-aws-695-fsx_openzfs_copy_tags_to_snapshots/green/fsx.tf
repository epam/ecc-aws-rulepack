resource "aws_fsx_openzfs_file_system" "this" {
  storage_capacity                = 64
  subnet_ids                      = [data.aws_subnets.this.ids[0]]
  deployment_type                 = "SINGLE_AZ_1"
  throughput_capacity             = 64

  root_volume_configuration {
    copy_tags_to_snapshots = true
    data_compression_type = "LZ4"
  }

  tags = {
    Name = "695_fsx_openzfs_file_system_green"
  }
}
