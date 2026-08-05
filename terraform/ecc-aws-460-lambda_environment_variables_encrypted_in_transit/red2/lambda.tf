# Lambda with CMK at-rest encryption and plaintext env vars (not encrypted in transit).
# ListFunctions returns Environment.Variables only when the caller has kms:Decrypt
# on this CMK; otherwise AWS embeds Environment.Error AccessDeniedException.

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "function/"
  output_path = "function.zip"
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    when        = destroy
    command     = "rm function.zip"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "aws_lambda_function" "this" {
  filename         = "function.zip"
  function_name    = "460_lambda_red_kms"
  role             = aws_iam_role.this.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.this.output_base64sha256
  kms_key_arn      = aws_kms_key.this.arn

  environment {
    variables = {
      foo = "bar"
    }
  }

  depends_on = [data.archive_file.this]
}
