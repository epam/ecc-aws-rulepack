resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "this" {
  name   = "212_security_group_red"
  vpc_id = aws_vpc.this.id
}

resource "aws_iam_role" "this" {
  name = "212_role_red"

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
  name = "212_policy_red"
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
  function_name = "212_lambda_red"
  role          = aws_iam_role.this.arn
  handler       = "func.py"

  vpc_config {
    subnet_ids         = [aws_subnet.subnet1.id]
    security_group_ids = [aws_security_group.this.id]
  }
  runtime = "python3.8"
}