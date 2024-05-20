resource "aws_sns_topic" "this" {
  name = module.naming.resource_prefix.sns

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:${module.naming.resource_prefix.sns}",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.this.arn}"}
        }
    }]
}
POLICY
}