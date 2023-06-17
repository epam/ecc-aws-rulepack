resource "aws_iam_role" "this" {
  name = "679_role_green"

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
  name = "679_policy_green"
  role = aws_iam_role.this.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "tag:GetResources",
            "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": "kms:Decrypt",
          "Resource": "${aws_kms_key.this.arn}",
          "Condition": {
            "StringEquals": {
              "kms:EncryptionContext:LambdaFunctionName": "679_lambda_green"
            }
          }
        }
    ]
}
  EOF
}

resource "aws_iam_role_policy_attachment" "this2" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
