# Currently, there is no way to encrypt environment variables using CLI or terraform.
# 1. To create green infrastructure, first, you have to deploy resources with terraform.
# 2. Navigate to a created lambda function, go to 'Configuration' -> 'Environment variables' -> 'Edit'.
# 3. Tick the checkbox 'Enable helpers for encryption in transit', then click on 'Encrypt', and select KMS Key created with terraform, click 'Save'.

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "function/"
  output_path = "function.zip"
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    when    = destroy
    command = "rm function.zip"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "aws_lambda_function" "this" {
  filename                       = "function.zip"
  function_name                  = "679_lambda_green"
  role                           = aws_iam_role.this.arn
  handler                        = "lambda_function.lambda_handler"
  runtime                        = "python3.9"
  source_code_hash               = data.archive_file.this.output_base64sha256
  environment {
    variables = {
      foo = "bar"
    }
  }

  depends_on = [data.archive_file.this]
}