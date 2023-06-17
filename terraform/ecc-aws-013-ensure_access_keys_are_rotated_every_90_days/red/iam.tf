resource "aws_iam_user" "this" {
  name          = "013_user_red"
  path          = "/"
  force_destroy = true
}