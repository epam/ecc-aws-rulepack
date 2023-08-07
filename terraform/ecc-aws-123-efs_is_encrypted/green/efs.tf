resource "aws_efs_file_system" "this" {
  creation_token = "123_efs_green"
  encrypted      = true
}