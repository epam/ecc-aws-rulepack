resource "aws_sns_topic" "this" {
  name = "sns-899-green"

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:sns-899-green",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.sns.arn}"}
        }
    }]
}
POLICY
}