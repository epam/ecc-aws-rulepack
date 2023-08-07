data "archive_file" "this" {
  type        = "zip"
  source_file = "welcome.py"
  output_path = "welcome.zip"
}

resource "aws_lambda_function" "this" {
  function_name    = "lambda-545-green"
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "welcome.lambda_handler"
  runtime          = "python3.9"
}