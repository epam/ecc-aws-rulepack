resource "aws_efs_file_system" "this" {
  creation_token = "510_efs_red"
  encrypted      = false
}
