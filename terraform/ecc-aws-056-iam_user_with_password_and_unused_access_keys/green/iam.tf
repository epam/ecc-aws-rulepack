resource "aws_iam_user" "this" {
  name = "056_user_green"
}

resource "aws_iam_access_key" "this" {
  user    = "${aws_iam_user.this.name}"
  pgp_key = "keybase:c7n"
}

output "this_iam_access_key_encrypted_secret" {
  value = "${aws_iam_access_key.this.encrypted_secret}"
}
