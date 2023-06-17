resource "aws_efs_file_system" "this" {
  creation_token = "337_efs_green"
  encrypted      = true
}

resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.this.id

  backup_policy {
    status = "ENABLED"
  }
}
