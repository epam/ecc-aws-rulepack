resource "aws_s3_bucket" "sns" {
  bucket = "899-sns-bucket-${random_integer.this.result}-green"
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket_ownership_controls" "sns" {
  bucket = aws_s3_bucket.sns.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "sns" {
  depends_on = [aws_s3_bucket_ownership_controls.sns]

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
  bucket = "899-sqs-bucket-${random_integer.this.result}-green"
}

resource "aws_s3_bucket_ownership_controls" "sqs" {
  bucket = aws_s3_bucket.sqs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "sqs" {
  depends_on = [aws_s3_bucket_ownership_controls.sqs]

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
  bucket = "899-lambda-bucket-${random_integer.this.result}-green"
}

resource "aws_s3_bucket_ownership_controls" "lambda" {
  bucket = aws_s3_bucket.lambda.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "lambda" {
  depends_on = [aws_s3_bucket_ownership_controls.lambda]

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