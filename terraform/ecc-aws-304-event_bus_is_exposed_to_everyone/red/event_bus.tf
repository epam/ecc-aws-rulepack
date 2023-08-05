data "aws_iam_policy_document" "this" {
  statement {
    sid    = "304_event_bus_policy_red"
    effect = "Allow"
    actions = [
      "events:DescribeEventBus",
    ]
    resources = [
      "arn:aws:events:us-east-1:111111111111:event-bus/304_event_bus_red"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_cloudwatch_event_bus_policy" "test" {
  policy         = data.aws_iam_policy_document.this.json
  event_bus_name = aws_cloudwatch_event_bus.this.name
}

resource "aws_cloudwatch_event_bus" "this" {
  name = "304_event_bus_red"
}
