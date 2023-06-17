resource "aws_iam_user" "this" {
  name = "277_user_red"
}

resource "aws_iam_access_key" "key1" {
  user = aws_iam_user.this.name
}

resource "aws_iam_access_key" "key2" {
  user = aws_iam_user.this.name
}