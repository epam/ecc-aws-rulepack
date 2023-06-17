data "aws_caller_identity" "current" {}

resource "aws_iam_role" "this" {
  name = "620_role_red"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
            "airflow-env.amazonaws.com", 
            "airflow.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "this" {
  name = "620_policy_red"
  role = aws_iam_role.this.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "airflow:PublishMetrics"
            ],
            "Resource": "arn:aws:airflow:${var.default-region}:${data.aws_caller_identity.current.account_id}:environment/mwaa_620_red"
        },
        {
            "Effect": "Allow",
            "Action": [
                "*"
            ],
            "Resource": [
                "${aws_s3_bucket.this.arn}",
                "${aws_s3_bucket.this.arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups"
            ],
            "Resource": ["*"]
        }
    ]
}
  EOF
}

