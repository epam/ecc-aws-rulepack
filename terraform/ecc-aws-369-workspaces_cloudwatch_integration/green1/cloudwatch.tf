# When there is no WorkSpaces and the CloudWatch event rule absent with a necessary configuration, it's also a green infrastructure. 

resource "aws_cloudwatch_event_rule" "this" {
  name = "369_cloudwatch_rule_green1"


  event_pattern = <<EOF
{
  "detail-type": [
    "AWS Console Sign In via CloudTrail"
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "SendToCloudWatchGroup"
  arn       = aws_cloudwatch_log_group.this.arn
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/events/369_cloudwatch_log_groupe_green1"
}