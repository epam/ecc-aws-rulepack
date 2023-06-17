resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/route53/${aws_route53_zone.this.name}"
  retention_in_days = 30
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:log-group:/aws/route53/*"]

    principals {
      identifiers = ["route53.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "this" {
  policy_document = data.aws_iam_policy_document.this.json
  policy_name     = "cloudwatch_log_resource_policy_green_513"
}

resource "aws_route53_zone" "this" {
  name = "513route53green.com"
}

resource "aws_route53_query_log" "this" {
  depends_on = [aws_cloudwatch_log_resource_policy.this]

  cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
  zone_id                  = aws_route53_zone.this.zone_id
}