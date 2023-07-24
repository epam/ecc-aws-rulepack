resource "aws_iam_role" "this" {
  name = "678_role_green"

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
  name = "678_policy_green"
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
  filename                = "func.zip"
  function_name           = "678_lambda_green"
  role                    = aws_iam_role.this.arn
  handler                 = "func.py"
  code_signing_config_arn = aws_lambda_code_signing_config.this.arn
  runtime                 = "python3.8"
}
