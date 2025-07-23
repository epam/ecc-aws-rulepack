resource "aws_iam_role" "this" {
  name = "086_role_red2"
  permissions_boundary = "arn:aws:iam::703671910212:policy/eo_role_boundary"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this1" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
}

resource "aws_iam_role_policy_attachment" "this2" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonBedrockReadOnly"
}

resource "aws_lambda_function" "this" {
  filename      = "func.zip"
  function_name = "086_lambda_red2"
  role          = aws_iam_role.this.arn
  handler       = "func.py"
  runtime       = "python3.12"
}