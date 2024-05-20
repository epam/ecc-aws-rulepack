output "fsx" {
  value = {
    fsx = aws_fsx_lustre_file_system.this.arn
    ecc-aws-333-fsx_all_types_of_file_systems_encrypted_with_kms_cmk = [
      aws_fsx_lustre_file_system.this.arn,
      aws_fsx_windows_file_system.this.arn,
      aws_fsx_openzfs_file_system.this.arn,
      aws_fsx_ontap_file_system.this.arn
    ]
    ecc-aws-465-fsx_daily_automatic_backup_enabled = [
      aws_fsx_lustre_file_system.this.arn,
      aws_fsx_windows_file_system.this.arn,
      aws_fsx_openzfs_file_system.this.arn,
      aws_fsx_ontap_file_system.this.arn
    ]
    fsx-backup = aws_fsx_backup.this.arn
    ecc-aws-466-fsx_netapp_ontap_multi_az_enabled = aws_fsx_ontap_file_system.this.arn
    ecc-aws-467-fsx_windows_file_server_multi_az_enabled = aws_fsx_windows_file_system.this.arn
  }
}
