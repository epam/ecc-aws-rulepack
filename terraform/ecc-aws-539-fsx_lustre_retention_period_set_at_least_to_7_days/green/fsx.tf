resource "aws_fsx_lustre_file_system" "this" {
  storage_capacity                = 6000
  subnet_ids                      = [aws_subnet.this1.id]
  automatic_backup_retention_days = 7
  deployment_type                 = "PERSISTENT_1"
  storage_type                    = "HDD"
  drive_cache_type                = "NONE"
  per_unit_storage_throughput     = 12
  copy_tags_to_backups            = true
}