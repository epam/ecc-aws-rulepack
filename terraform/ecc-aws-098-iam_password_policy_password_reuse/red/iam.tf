resource "aws_iam_account_password_policy" "this" {
  password_reuse_prevention      = 3
}