resource "aws_iam_access_key" "this" {
  user    = "${aws_iam_user.this.name}"
  pgp_key = "keybase:c7n"
}

resource "aws_iam_user" "this" {
  name = "002_user_green"
}

output "this_iam_access_key_encrypted_secret" {
  value = "${aws_iam_access_key.this.encrypted_secret}"
}