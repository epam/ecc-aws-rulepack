resource "aws_s3_bucket" "sns" {
  bucket = "899-sns-s3-bucket-green"
}

resource "aws_s3_bucket_acl" "sns" {
  bucket = aws_s3_bucket.sns.id
  acl    = "private"
}

resource "aws_s3_bucket_notification" "sns" {
  bucket = aws_s3_bucket.sns.id

  topic {
    topic_arn     = aws_sns_topic.this.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}

resource "aws_s3_bucket" "sqs" {
  bucket = "899-sqs-s3-bucket-green"
}

resource "aws_s3_bucket_acl" "sqs" {
  bucket = aws_s3_bucket.sqs.id
  acl    = "private"
}

resource "aws_s3_bucket_notification" "sqs" {
  bucket = aws_s3_bucket.sqs.id
  queue {
    queue_arn     = aws_sqs_queue.this.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}

resource "aws_s3_bucket" "lambda" {
  bucket = "899-lambda-s3-bucket-green"
}

resource "aws_s3_bucket_acl" "lambda" {
  bucket = aws_s3_bucket.lambda.id
  acl    = "private"
}

resource "aws_s3_bucket_notification" "lambda" {
  bucket = aws_s3_bucket.lambda.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.this.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log"
  }

  depends_on = [aws_lambda_permission.this]
}