resource "aws_iam_user" "this" {
  name = "113_user_green"
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_iam_policy" "this" {
  name = "113_policy_green"

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
  name       = "113_policy_attachment_green"
  users      = [aws_iam_user.this.name]
  policy_arn = aws_iam_policy.this.arn
}