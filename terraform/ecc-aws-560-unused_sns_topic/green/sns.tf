resource "aws_sns_topic" "this" {
  name = "560-sns-green"
}

resource "aws_sqs_queue" "this" {
  name = "560-sqs-green"
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
      "--profile ${var.profile}",
      "--region ${var.default-region}"
      ]
    )
  }

  depends_on = [aws_sns_topic_subscription.this]
}