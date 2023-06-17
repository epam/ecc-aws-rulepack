data "archive_file" "this" {
  type        = "zip"
  source_dir  = "function/"
  output_path = "function.zip"
}

resource "aws_lambda_function" "this" {
  filename      = "function.zip"
  function_name = "677_lambda_green"
  role          = aws_iam_role.this.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  layers        = ["arn:aws:lambda:${var.default-region}:580247275435:layer:LambdaInsightsExtension:21"]
  depends_on    = [data.archive_file.this]
}

data "aws_caller_identity" "current" {}