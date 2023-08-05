resource "aws_lambda_function" "this" {
  filename         = "lambda_function.zip"
  function_name    = "219_lambda_function_green"
  role             = aws_iam_role.this.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime          = "python3.7"

  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.us-east-1.amazonaws.com"
      EXCLUDE_CHRACTERS        = "/@\"'\\ "
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.this1.id, aws_subnet.this2.id]
    security_group_ids = [aws_security_group.this.id]
  }

}

resource "aws_lambda_permission" "this" {
  function_name = aws_lambda_function.this.function_name
  statement_id  = "AllowExecutionSecretManager"
  action        = "lambda:InvokeFunction"
  principal     = "secretsmanager.amazonaws.com"
}

