resource "aws_cloudwatch_event_rule" "this" {
  name = "369_cloudwatch_rule_red"


  event_pattern = <<EOF
{
  "detail-type": [
    "AWS Console Sign In via CloudTrail"
  ]
}
EOF
}
