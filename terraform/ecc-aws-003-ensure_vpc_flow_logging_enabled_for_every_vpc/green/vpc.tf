resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_flow_log" "this" {
  iam_role_arn    = "${aws_iam_role.this.arn}"
  log_destination = "${aws_cloudwatch_log_group.this.arn}"
  traffic_type    = "REJECT"
  vpc_id          = "${aws_vpc.this.id}"
}

resource "aws_cloudwatch_log_group" "this" {
  name = "003_log_group_green"
}

resource "aws_iam_role" "this" {
  name = "003_role_green"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "this" {
  name = "003_policy_green"
  role = "${aws_iam_role.this.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}