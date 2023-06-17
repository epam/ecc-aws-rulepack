resource "aws_iam_role" "this" {
  name = "672_role_red"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "this" {
  name = "672_policy_red"
  role = "${aws_iam_role.this.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::bucket-672-red/*"]
  }
}