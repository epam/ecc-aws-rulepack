resource "aws_iam_user" "this" {
  name = "514_user_red"
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
  status = "Inactive"
}
