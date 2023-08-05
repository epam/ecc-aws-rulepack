resource "aws_efs_file_system" "this" {
  creation_token = "124_efs_red"
  encrypted      = true
}
