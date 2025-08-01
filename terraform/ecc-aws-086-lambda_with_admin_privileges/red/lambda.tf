resource "aws_iam_role" "this" {
  name = "086_role_red"

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

resource "aws_iam_role_policy" "this" {
  name = "086_policy_red"
  role = aws_iam_role.this.id

  policy = <<-EOF
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

resource "aws_lambda_function" "this" {
  filename      = "func.zip"
  function_name = "086_lambda_red"
  role          = aws_iam_role.this.arn
  handler       = "func.py"
  runtime       = "python3.12"
}