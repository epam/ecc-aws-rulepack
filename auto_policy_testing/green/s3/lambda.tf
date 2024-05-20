resource "aws_lambda_function" "this" {
  filename      = "func.zip"
  function_name = module.naming.resource_prefix.lambda_function
  role          = aws_iam_role.this2.arn
  handler       = "func.lambda_handler"
  runtime       = "python3.12"
  depends_on    = [data.archive_file.this]
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.this3.arn
}

data "archive_file" "this" {
  type        = "zip"
  source_file = "func.py"
  output_path = "func.zip"
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    when        = destroy
    command     = "rm func.zip"
    interpreter = ["/bin/bash", "-c"]
  }
}