resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt FSx"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "this" {
  name          = "alias/495-green"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_fsx_lustre_file_system" "this" {
  storage_capacity                = 6000
  subnet_ids                      = [aws_subnet.this1.id]
  kms_key_id                      = aws_kms_key.this.arn
  automatic_backup_retention_days = 0
  deployment_type                 = "PERSISTENT_1"
  storage_type                    = "HDD"
  drive_cache_type                = "NONE"
  per_unit_storage_throughput     = 12

}
