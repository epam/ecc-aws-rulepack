# Enable MFA manually 

resource "aws_iam_user" "this" {
  name          = "001_user_green"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_policy" "this" {
  name        = "001_policy_green"
  description = "ensure mfa is enabled for all users policy"

policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iam:CreateVirtualMFADevice",
        "iam:ListMFADevices",
        "iam:GetAccountPasswordPolicy",
        "iam:ChangePassword"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = "${aws_iam_user.this.name}"
  policy_arn = "${aws_iam_policy.this.arn}"
}

resource "aws_iam_user_login_profile" "this" {
  user    = "${aws_iam_user.this.name}"
  pgp_key = "keybase:c7n"
}

output "this_iam_user_login_profile_encrypted_password" {
  value = "${aws_iam_user_login_profile.this.encrypted_password}"
}
