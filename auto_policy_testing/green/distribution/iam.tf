
resource "aws_iam_role" "this" {
  name               = "${module.naming.resource_prefix.iam_role}"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_role_policy" "this" {
  name   = "${module.naming.resource_prefix.iam_role}"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.permissions.json
}

data "aws_iam_policy_document" "assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "permissions" {
  statement {
    effect = "Allow"

    actions = [
      "kinesis:DescribeStreamSummary",
      "kinesis:DescribeStream",
      "kinesis:PutRecord",
      "kinesis:PutRecords",
    ]

    resources = [aws_kinesis_stream.this.arn]
  }
}
