# Created because AWS IAM credentials report can be generated only once per 4 hours.
# This way ensures that whether green or red terraform deployed first the report will have both users. 
# There won't be necessary to wait 4 hour difference to see red user in the report.
# For policies:
# ecc-aws-001-ensure_mfa_is_enabled_for_all_iam_users_with_console_password
# ecc-aws-514-inactive_iam_access_keys_are_not_deleted


# ecc-aws-001-ensure_mfa_is_enabled_for_all_iam_users_with_console_password
resource "aws_iam_user" "red1" {
  name          = "autotest_iam_user_red-1"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_access_key" "red1_1" {
  user = aws_iam_user.red1.name
}

resource "aws_iam_access_key" "red1_2" {
  user = aws_iam_user.red1.name
}


resource "aws_iam_user_login_profile" "red1" {
  user = aws_iam_user.red1.name
}

# ecc-aws-514-inactive_iam_access_keys_are_not_deleted
resource "aws_iam_user" "red2" {
  name = "autotest_iam_user_red2"
}

resource "aws_iam_access_key" "red2" {
  user   = aws_iam_user.red2.name
  status = "Inactive"
}
