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

resource "aws_lambda_function" "this" {
  function_name    = "${module.naming.resource_prefix.step_function}"
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "func.lambda_handler"
  runtime          = "python3.9"
}
