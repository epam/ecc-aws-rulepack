data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "${module.naming.resource_prefix.event_bus}"
    effect = "Allow"
    actions = [
      "events:DescribeEventBus",
    ]
    resources = [
      "arn:aws:events:${var.region}:${data.aws_caller_identity.current.account_id}:event-bus/${module.naming.resource_prefix.event_bus}"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}