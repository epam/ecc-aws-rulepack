resource "aws_efs_file_system" "this" {
  creation_token = "123_efs_red"
  encrypted      = false
}
