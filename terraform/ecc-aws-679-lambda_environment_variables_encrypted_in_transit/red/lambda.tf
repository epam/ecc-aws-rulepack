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
  function_name                  = "679_lambda_red"
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