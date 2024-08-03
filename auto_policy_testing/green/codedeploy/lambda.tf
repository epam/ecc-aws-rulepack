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

resource "null_resource" "this1" {
  provisioner "local-exec" {
    when        = destroy
    command     = "rm lambda_code_v1.zip lambda_code_v2.zip"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "aws_lambda_function" "this" {
  filename      = "lambda_code_v1.zip"
  function_name = module.naming.resource_prefix.lambda_function
  role          = aws_iam_role.this2.arn
  handler       = "lambda_function_v1.lambda_handler"
  runtime       = "python3.10"
  publish       = true

  depends_on = [data.archive_file.this1]
}

resource "aws_lambda_alias" "this" {
  name             = "${module.naming.resource_prefix.lambda_function}-alias"
  description      = "${module.naming.resource_prefix.lambda_function}-alias"
  function_name    = aws_lambda_function.this.function_name
  function_version = aws_lambda_function.this.version
}

resource "null_resource" "this2" {
  provisioner "local-exec" {
    command     = "aws lambda update-function-code --function-name  ${aws_lambda_function.this.function_name} --zip-file fileb://lambda_code_v2.zip --publish"
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [aws_lambda_function.this, data.archive_file.this2]
}

data "aws_lambda_function" "this" {
  function_name = aws_lambda_function.this.function_name

  depends_on = [ null_resource.this2 ]
}