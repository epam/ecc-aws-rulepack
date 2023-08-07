resource "aws_iam_user" "this" {
  name = "056_user_red"
}

resource "aws_iam_access_key" "this" {
  user    = "${aws_iam_user.this.name}"
  pgp_key = "keybase:c7n"
}

output "this_iam_access_key_encrypted_secret" {
  value = "${aws_iam_access_key.this.encrypted_secret}"
}
resource "aws_iam_user_login_profile" "this" {
  user    = "${aws_iam_user.this.name}"
  pgp_key = "keybase:c7n"
}

output "this_iam_user_login_profile_encrypted_password" {
  value = "${aws_iam_user_login_profile.this.encrypted_password}"
}