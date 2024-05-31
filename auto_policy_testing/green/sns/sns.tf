resource "aws_sns_topic" "this" {
  name                           = "${module.naming.resource_prefix.sns}"
  kms_master_key_id              = data.terraform_remote_state.common.outputs.kms_key_arn
  http_success_feedback_role_arn = aws_iam_role.this.arn
  http_failure_feedback_role_arn = aws_iam_role.this.arn
}

resource "aws_sqs_queue" "this" {
  name = "${module.naming.resource_prefix.sqs}"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.this.arn
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    command = join(" ", [
      "aws sns publish ",
      "--topic-arn ${aws_sns_topic.this.arn}",
      "--message 'Hello World!'",
      "--region ${var.region}"
      ]
    )
  }

  depends_on = [aws_sns_topic_subscription.this]
}

resource "aws_iam_role" "this" {
  name                = "${module.naming.resource_prefix.iam_role}"
  assume_role_policy  = data.aws_iam_policy_document.this.json
  managed_policy_arns = [aws_iam_policy.this.arn]
}

resource "aws_iam_policy" "this" {
  name = "${module.naming.resource_prefix.iam_policy}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                    "logs:PutMetricFilter",
                    "logs:PutRetentionPolicy"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
