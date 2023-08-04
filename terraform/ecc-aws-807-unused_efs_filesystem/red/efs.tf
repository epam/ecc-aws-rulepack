resource "aws_efs_file_system" "this" {
  creation_token = "807_efs_red"
  encrypted      = false
}
