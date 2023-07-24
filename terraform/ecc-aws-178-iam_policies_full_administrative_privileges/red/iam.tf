resource "aws_iam_user" "this" {
  name = "178_user_red"
}

resource "aws_iam_access_key" "this" {
  user    = aws_iam_user.this.name
  pgp_key = "keybase:c7n"
}

output "this_iam_access_key_encrypted_secret" {
  value = aws_iam_access_key.this.encrypted_secret
}

resource "aws_iam_policy" "this" {
  name = "178_policy_red"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "this" {
  name       = "178_policy_attachment_red"
  users      = ["${aws_iam_user.this.name}"]
  policy_arn = aws_iam_policy.this.arn
}