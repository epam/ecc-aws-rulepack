resource "aws_cloudwatch_event_rule" "this" {
  name = "369_cloudwatch_rule_green"


  event_pattern = <<EOF
{
  "source": ["aws.workspaces"],
  "detail-type": ["WorkSpaces Access"]
}
EOF
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "SendToCloudWatchGroup"
  arn       = aws_cloudwatch_log_group.this.arn
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/events/369_cloudwatch_log_groupe_green"
}