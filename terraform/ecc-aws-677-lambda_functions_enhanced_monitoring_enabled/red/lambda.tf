data "archive_file" "this" {
  type        = "zip"
  source_dir  = "function/"
  output_path = "function.zip"
}

resource "aws_lambda_function" "this" {
  filename                       = "function.zip"
  function_name                  = "677_lambda_red"
  role                           = aws_iam_role.this.arn
  handler                        = "lambda_function.lambda_handler"
  runtime                        = "python3.9"
  depends_on = [data.archive_file.this]
}
