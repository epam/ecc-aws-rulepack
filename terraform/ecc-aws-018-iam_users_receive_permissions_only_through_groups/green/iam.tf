resource "aws_iam_user" "this" {
  name = "018_user_green"
}

resource "aws_iam_access_key" "this" {
  user    = "${aws_iam_user.this.name}"
  pgp_key = "keybase:c7n"
}

output "this_aws_iam_access_key_encrypted_secret" {
  value = "${aws_iam_access_key.this.encrypted_secret}"
}

resource "aws_iam_group" "this" {
  name = "018_group_green"
}

resource "aws_iam_policy" "this" {
  name   = "018_policy_green"
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

resource "aws_iam_group_policy_attachment" "this" {
  group      = "${aws_iam_group.this.name}"
  policy_arn = "${aws_iam_policy.this.arn}"
}

resource "aws_iam_group_membership" "this" {
  name = "018_group_membership_green"
  users = [
    "${aws_iam_user.this.name}"
  ]
  group = "${aws_iam_group.this.name}"
}

resource "aws_iam_role" "this" {
  name = "018_role_green"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = "${aws_iam_role.this.name}"
  policy_arn = "${aws_iam_policy.this.arn}"
}