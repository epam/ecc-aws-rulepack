# This filter checks the account for 4 errors
# - the password has been used, but it's been used for 45 days.
# - the password hasn't been used and it's 45 days old.
# - the access_key has been used, but it's been used for 45 days.
# - the access_key hasn't been used and it's 45 days old.


#the password hasn't been used and it's 45 days old.
resource "aws_iam_user" "no_used_pswd" {
  name = "017_no_used_pswd_user_green"
}

#the access_key hasn't been used and it's 45 days old.
resource "aws_iam_user" "no_used_access" {
  name = "017_no_used_access_user_green"
}

#the password has been used, but it's been used for 45 days. -unenforceable 
resource "aws_iam_user" "used_pswd" {
  name = "017_used_pswd_user_green"
}

#the access_key hasn't been used and it's 45 days old. -unenforceable 
resource "aws_iam_user" "used_access" {
  name = "017_used_access_user_green"
}

resource "aws_iam_access_key" "no_used_access" {
  user    = "${aws_iam_user.no_used_access.name}"
  pgp_key = "keybase:c7n"
}

resource "aws_iam_access_key" "used_access" {
  user    = "${aws_iam_user.used_access.name}"
  pgp_key = "keybase:c7n"
}

output "secret" {
  value = "${aws_iam_access_key.no_used_access.encrypted_secret}"
}

output "secret1" {
  value = "${aws_iam_access_key.used_access.encrypted_secret}"
}


resource "aws_iam_user_login_profile" "no_used_pswd" {
  user    = "${aws_iam_user.no_used_pswd.name}"
  pgp_key = "keybase:c7n"
}

output "password" {
  value = "${aws_iam_user_login_profile.no_used_pswd.encrypted_password}"
}

resource "aws_iam_user_login_profile" "used_pswd" {
  user    = "${aws_iam_user.used_pswd.name}"
  pgp_key = "keybase:c7n"
}

output "used_pswd_iam_user_login_profile_encrypted_password" {
  value = "${aws_iam_user_login_profile.used_pswd.encrypted_password}"
}

resource "aws_iam_group" "this" {
  name = "017_group_green"
}

resource "aws_iam_group_membership" "this" {
  name = "017_group_membership_green"

  users = [
    "${aws_iam_user.no_used_pswd.name}",
    "${aws_iam_user.used_pswd.name}",
    "${aws_iam_user.no_used_access.name}",
    "${aws_iam_user.used_access.name}"
  ]

  group = "${aws_iam_group.this.name}"
}

resource "aws_iam_group_policy" "this" {
  name  = "017_policy_green"
  group = "${aws_iam_group.this.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}