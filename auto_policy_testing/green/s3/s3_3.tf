resource "aws_s3_bucket" "this3" {
  bucket = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}-3"
}

# resource "aws_s3_bucket_ownership_controls" "this3" {
#   bucket = aws_s3_bucket.this3.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "this3" {
#   depends_on = [aws_s3_bucket_ownership_controls.this3]

#   bucket = aws_s3_bucket.this3.id
#   acl    = "private"
# }

resource "aws_s3_bucket_notification" "this3" {
  bucket = aws_s3_bucket.this3.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.this.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log"
  }

  depends_on = [aws_lambda_permission.this]
}