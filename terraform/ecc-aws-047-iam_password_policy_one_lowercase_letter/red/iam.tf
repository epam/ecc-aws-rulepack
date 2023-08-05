resource "aws_iam_account_password_policy" "this" {
  require_lowercase_characters   = false
}