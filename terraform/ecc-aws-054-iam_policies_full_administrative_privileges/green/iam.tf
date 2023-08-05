resource "aws_iam_user" "this" {
  name = "054_user_green"
}

resource "aws_iam_access_key" "this" {
  user    = aws_iam_user.this.name
  pgp_key = "keybase:c7n"
}

output "this_iam_access_key_encrypted_secret" {
  value = aws_iam_access_key.this.encrypted_secret
}

resource "aws_iam_policy" "this" {
  name = "054_policy_green"

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

resource "aws_iam_policy_attachment" "this" {
  name       = "054_policy_attachment_green"
  users      = ["${aws_iam_user.this.name}"]
  policy_arn = aws_iam_policy.this.arn
}