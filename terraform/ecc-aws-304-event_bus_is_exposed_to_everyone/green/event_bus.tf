data "aws_iam_policy_document" "this" {
  statement {
    sid    = "304_event_bus_policy_green"
    effect = "Allow"
    actions = [
      "events:DescribeEventBus",
    ]
    resources = [
      "arn:aws:events:us-east-1:111111111111:event-bus/304_event_bus_green"
    ]

    principals {
      type        = "AWS"
      identifiers = ["111111111111"]
    }
  }
}

resource "aws_cloudwatch_event_bus_policy" "test" {
  policy         = data.aws_iam_policy_document.this.json
  event_bus_name = aws_cloudwatch_event_bus.this.name
}

resource "aws_cloudwatch_event_bus" "this" {
  name = "304_event_bus_green"
}
