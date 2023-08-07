resource "aws_sns_topic" "this" {
  name = "098_sns_red1"
}

resource "null_resource" "create_subscription" {
  provisioner "local-exec" {
    command = join(" ", [
      "aws sns subscribe",
      "--topic-arn ${aws_sns_topic.this.arn}",
      "--protocol email",
      "--notification-endpoint ${var.test-email}",
      "--profile ${var.profile}",
      "--region ${var.default-region}"
      ]
    )
  }
}