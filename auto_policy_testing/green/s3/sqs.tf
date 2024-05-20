resource "aws_sqs_queue" "this" {
  name = module.naming.resource_prefix.sqs

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:${module.naming.resource_prefix.sqs}",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${aws_s3_bucket.this2.arn}" }
      }
    }
  ]
}
POLICY
}