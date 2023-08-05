resource "aws_iam_role" "this" {
  name = "058_role_green"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow"
        Principal = {
          AWS = "876320341958"
        }
      },
    ]
  })
}

data "aws_iam_policy" "this" {
  arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.this.arn
}