resource "aws_iam_user" "this" {
  name = "097_user_red"
}
resource "aws_iam_access_key" "this" {
  user    = "${aws_iam_user.this.name}"
  pgp_key = "keybase:c7n"
}
output "secret1" {
  value = "${aws_iam_access_key.this.encrypted_secret}"
}
resource "aws_iam_policy" "this" {
  name   = "097_policy_red"
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
resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.this.arn
}