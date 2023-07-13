resource "aws_sqs_queue" "this" {
  name = "450_sqs_green"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.this2.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sqs_queue" "this2" {
  name = "450_sqs_green1"
}

resource "aws_sqs_queue_redrive_allow_policy" "this" {
  queue_url = aws_sqs_queue.this2.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.this.arn]
  })
}
