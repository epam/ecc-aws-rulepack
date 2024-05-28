output "sns" {
  value = {
    sns = aws_sns_topic.this.arn
  }
}
