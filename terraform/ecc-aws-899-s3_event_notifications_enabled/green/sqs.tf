resource "aws_sqs_queue" "this" {
  name = "899_sqs_green"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:899_sqs_green",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${aws_s3_bucket.sqs.arn}" }
      }
    }
  ]
}
POLICY
}