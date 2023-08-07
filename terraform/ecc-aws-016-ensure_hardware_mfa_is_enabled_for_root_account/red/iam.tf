
resource "aws_iam_user" "this" {
  name          = "016_user_red"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "this" {
  user    = "${aws_iam_user.this.name}"
  pgp_key = "keybase:c7n"
}

output "this_iam_user_login_profile_encrypted_password" {
  value = "${aws_iam_user_login_profile.this.encrypted_password}"
}