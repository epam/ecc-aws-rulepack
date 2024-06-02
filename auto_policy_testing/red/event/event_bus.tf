resource "aws_cloudwatch_event_bus_policy" "this" {
  policy         = data.aws_iam_policy_document.this.json
  event_bus_name = aws_cloudwatch_event_bus.this.name
}

resource "aws_cloudwatch_event_bus" "this" {
  name = "${module.naming.resource_prefix.event_bus}"
}
