#If an error occurred while creating the Lambda function, rename it in terraform. For some reason, after a function was destroyed and recreated with the same name, AWS keeps track of Lambda versions and continues versioning where it left off, rather than starting at number 1.

data "archive_file" "this1" {
  type        = "zip"
  source_file = "${path.module}/lambda_function_v1.py"
  output_path = "lambda_code_v1.zip"
}

data "archive_file" "this2" {
  type        = "zip"
  source_file = "${path.module}/lambda_function_v2.py"
  output_path = "lambda_code_v2.zip"
}

resource "aws_lambda_function" "this" {
  filename      = "lambda_code_v1.zip"
  function_name = "484_lambda_fun_green"
  role          = aws_iam_role.this.arn
  handler       = "lambda_function_v1.lambda_handler"
  runtime       = "python3.8"
  publish       = true

  depends_on = [data.archive_file.this1]
}

resource "aws_lambda_alias" "this" {
  name             = "484_lambda_alias_green"
  description      = "a sample description"
  function_name    = "484_lambda_fun_green"
  function_version = "1"
  depends_on       = [aws_lambda_function.this]
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    command     = "aws lambda update-function-code --function-name 484_lambda_fun_green --zip-file fileb://lambda_code_v2.zip --publish"
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [aws_lambda_function.this, aws_lambda_alias.this, data.archive_file.this2]
}