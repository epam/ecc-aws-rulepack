resource "aws_lambda_function" "this" {
  filename                           = "lambda_function.zip"
  function_name                      = module.naming.resource_prefix.lambda_function
  role                               = aws_iam_role.this.arn
  handler                            = "lambda_function.lambda_handler"
  source_code_hash                   = filebase64sha256("lambda_function.zip")
  runtime                            = "python3.12"
  replace_security_groups_on_destroy = true

  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://${aws_vpc_endpoint.this.dns_entry[0].dns_name}"
      EXCLUDE_CHRACTERS        = "/@\"'\\ "
    }
  }

  vpc_config {
    subnet_ids         = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_3_id]
    security_group_ids = [aws_security_group.this.id]
  }

  depends_on = [
    aws_vpc_endpoint.this,
    aws_iam_role_policy.this1,
    aws_iam_role_policy.this2,
    aws_iam_role_policy_attachment.this1
  ]
}

resource "aws_lambda_permission" "this" {
  function_name = aws_lambda_function.this.function_name
  statement_id  = "AllowExecutionSecretManager"
  action        = "lambda:InvokeFunction"
  principal     = "secretsmanager.amazonaws.com"
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/lambda/${aws_lambda_function.this.function_name}"
}