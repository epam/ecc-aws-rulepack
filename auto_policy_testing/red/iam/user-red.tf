resource "aws_iam_user" "red1" {
  provider      = aws.provider2
  name          = "autotest_iam_user_red-1"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_access_key" "red1_1" {
  user = aws_iam_user.red1.name
}

resource "aws_iam_access_key" "red1_2" {
  user = aws_iam_user.red1.name
}

resource "aws_iam_user_login_profile" "red1" {
  user = aws_iam_user.red1.name
}

resource "aws_iam_user_policy_attachment" "red" {
  user       = aws_iam_user.red1.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_user_policy" "red" {
  name = "${module.naming.resource_prefix.iam_policy}-red"
  user = aws_iam_user.red1.name

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

# ecc-aws-514-inactive_iam_access_keys_are_not_deleted
resource "aws_iam_user" "red2" {
  name = "autotest_iam_user_red2"
}

resource "aws_iam_access_key" "red2" {
  user   = aws_iam_user.red2.name
  status = "Inactive"
}