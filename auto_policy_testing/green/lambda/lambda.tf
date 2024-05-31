resource "aws_security_group" "this" {
  name   = "${module.naming.resource_prefix.lambda_function}"
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
}

resource "aws_kms_ciphertext" "this" {
  key_id = data.terraform_remote_state.common.outputs.kms_key_arn

  plaintext = "bar"
}

# Due to AWS Lambda improved VPC networking changes that began deploying in September 2019, EC2 subnets and security groups associated with Lambda Functions can take up to 45 minutes to successfully delete.

resource "aws_lambda_function" "this" {
  filename                       = "func.zip"
  function_name                  = "${module.naming.resource_prefix.lambda_function}"
  role                           = aws_iam_role.this.arn
  handler                        = "func.lambda_handler"
  kms_key_arn                    = data.terraform_remote_state.common.outputs.kms_key_arn
  runtime                        = "python3.12"
  reserved_concurrent_executions = 1 
  layers                         = ["arn:aws:lambda:${var.region}:580247275435:layer:LambdaInsightsExtension:52"]
  replace_security_groups_on_destroy = true

  vpc_config {
    security_group_ids = [aws_security_group.this.id]
    subnet_ids         = [
      data.terraform_remote_state.common.outputs.vpc_subnet_1_id,
      data.terraform_remote_state.common.outputs.vpc_subnet_2_id,
    ]
  }

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      foo = aws_kms_ciphertext.this.ciphertext_blob
    }
  }
}