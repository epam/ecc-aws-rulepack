resource "aws_iam_user" "this" {
  name          = "002_user_red"
  path          = "/"
  force_destroy = true
}