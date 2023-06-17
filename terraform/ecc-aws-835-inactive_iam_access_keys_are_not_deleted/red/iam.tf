resource "aws_iam_user" "this" {
  name = "835_user_red"
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
  status = "Inactive"
}
