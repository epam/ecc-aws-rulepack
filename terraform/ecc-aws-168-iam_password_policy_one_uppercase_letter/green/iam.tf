resource "aws_iam_account_password_policy" "this" {
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_symbols                = true
  require_numbers                = true
  minimum_password_length        = 14
  password_reuse_prevention      = 24  
  max_password_age = 90
}