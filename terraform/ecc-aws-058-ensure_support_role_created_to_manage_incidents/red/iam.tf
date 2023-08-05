resource "aws_iam_role" "this" {
  name               = "058_role_red"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "876320341958"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}