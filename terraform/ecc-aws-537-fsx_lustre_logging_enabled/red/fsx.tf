resource "aws_fsx_lustre_file_system" "this" {
  storage_capacity            = 6000
  subnet_ids                  = [data.aws_subnets.this.ids[0]]
  deployment_type             = "PERSISTENT_1"
  storage_type                = "HDD"
  drive_cache_type            = "NONE"
  per_unit_storage_throughput = 12
  tags = {
    Name = "537-fsx_lustre_file_system-red"
  }
}