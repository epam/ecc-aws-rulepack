# wrong
resource "aws_sns_topic" "this1" {
  name = "${module.naming.resource_prefix.sns}-1"
  policy = <<EOT
{
  "Statement": [
  {
    "Sid": "allow_all",
    "Effect": "Allow",
    "Principal": {
      "AWS": "*"
    },
    "Action": ["sns:GetTopicAttributes"],
    "Resource": ["arn:aws:sns:${var.region}:${data.aws_caller_identity.this.account_id}:${module.naming.resource_prefix.sns}-1"]
  },
  {   
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish",
        "SNS:Receive"
      ],
      "Resource": "arn:aws:sns:${var.region}:${data.aws_caller_identity.this.account_id}:${module.naming.resource_prefix.sns}-1",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": ${data.aws_caller_identity.this.account_id}
        }
      }
    }
  ]
}
EOT
}

# correct
resource "aws_sns_topic" "this2" {
  name = "${module.naming.resource_prefix.sns}-2"
}

resource "aws_sqs_queue" "this" {
  name = module.naming.resource_prefix.sqs
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this2.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.this.arn
}
