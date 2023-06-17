resource "aws_efs_file_system" "this" {
  creation_token = "257_efs_green"
  encrypted      = true
}