output "fsx" {
  value = {
    fsx                                                  = aws_fsx_lustre_file_system.this.id
    ecc-aws-465-fsx_daily_automatic_backup_enabled       = aws_fsx_lustre_file_system.this.id
    ecc-aws-466-fsx_netapp_ontap_multi_az_enabled        = aws_fsx_ontap_file_system.this.id
    fsx-backup                                           = aws_fsx_backup.this.id
    ecc-aws-467-fsx_windows_file_server_multi_az_enabled = aws_fsx_windows_file_system.this.id
  }
}
