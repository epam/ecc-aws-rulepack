resource "aws_efs_file_system" "this" {
  creation_token = "257_efs_red"
  encrypted      = false
}
