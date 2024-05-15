output "fsx" {
  value = {
    fsx = aws_fsx_lustre_file_system.this.arn
    fsx-backup = aws_fsx_backup.this.id
    ecc-aws-467-fsx_windows_file_server_multi_az_enabled = aws_fsx_windows_file_system.this.arn
  }
}
