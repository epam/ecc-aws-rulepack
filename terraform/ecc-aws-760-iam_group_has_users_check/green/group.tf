resource "aws_iam_group" "this" {
  name = "760-group-green"
  path = "/"
}

resource "aws_iam_group_membership" "this" {
  name = "760-group-membership-green"

  users = [
    aws_iam_user.this.name,
  ]

  group = aws_iam_group.this.name
}

resource "aws_iam_user" "this" {
  name = "760-user-green"
}