data "archive_file" "this1" {
  type        = "zip"
  source_file = "${path.module}/lambda_function_v1.py"
  output_path = "lambda_code_v1.zip"
}
resource "null_resource" "this1" {
  provisioner "local-exec" {
    when        = destroy
    command     = "rm lambda_code_v1.zip"
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