resource "aws_efs_file_system" "this" {
  creation_token = "191_efs_red"
  encrypted      = true
}

resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.this.id

  backup_policy {
    status = "DISABLED"
  }
}
