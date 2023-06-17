resource "aws_iam_role" "this" {
  name = "500_role_red"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "this" {
  name = "500_policy_red"
  role = aws_iam_role.this.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeNetworkInterfaces",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeInstances",
                "ec2:AttachNetworkInterface"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}

resource "aws_lambda_function" "this" {
  filename      = "func.zip"
  function_name = "500_lambda_red"
  role          = aws_iam_role.this.arn
  handler       = "func.py"
  runtime       = "python3.8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
