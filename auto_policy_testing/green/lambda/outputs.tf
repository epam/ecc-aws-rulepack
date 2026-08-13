output "lambda" {
  value = {
    lambda                                     = aws_lambda_function.this.arn
    ecc-aws-536-lambda_function_settings_check = aws_lambda_function.supported_runtime.arn
  }
}
