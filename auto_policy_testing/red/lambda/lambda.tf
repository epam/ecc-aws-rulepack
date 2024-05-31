resource "aws_security_group" "this" {
  name   = "${module.naming.resource_prefix.lambda_function}"
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
}

resource "aws_lambda_function" "this" {
  provider      = aws.provider2
  filename      = "func.zip"
  function_name = module.naming.resource_prefix.lambda_function
  role          = aws_iam_role.this.arn
  handler       = "func.lambda_handler"
  runtime       = "python3.8"
  replace_security_groups_on_destroy = true

  vpc_config {
    security_group_ids = [aws_security_group.this.id]
    subnet_ids         = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id]
  }

  environment {
    variables = {
      foo = "bar"
    }
  }
}