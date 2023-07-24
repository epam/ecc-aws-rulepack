resource "aws_sns_topic" "this" {
  name = "209-sns-green"
}

resource "null_resource" "this" {
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