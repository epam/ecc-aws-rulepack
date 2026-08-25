locals {
  # Public AWS-owned Lambda Insights extension (not the caller account)
  lambda_insights_layer = "arn:aws:lambda:${var.region}:580247275435:layer:LambdaInsightsExtension:55"
}

resource "aws_security_group" "this" {
  name   = module.naming.resource_prefix.lambda_function
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
}

resource "aws_iam_role" "this" {
  name                 = module.naming.resource_prefix.lambda_function

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "this" {
  name = module.naming.resource_prefix.lambda_function
  role = aws_iam_role.this.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeNetworkInterfaces",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeInstances",
                "ec2:AttachNetworkInterface"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}

resource "aws_iam_role_policy_attachment" "insights" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

# Primary green function: latest runtime (461), Insights (458), CMK (337), no plaintext env (460)
resource "aws_lambda_function" "this" {
  filename                       = "func.zip"
  function_name                  = module.naming.resource_prefix.lambda_function
  role                           = aws_iam_role.this.arn
  handler                        = "func.lambda_handler"
  kms_key_arn                    = data.terraform_remote_state.common.outputs.kms_key_arn
  runtime                        = "python3.12"
  reserved_concurrent_executions = 1
  layers                         = [local.lambda_insights_layer]

  vpc_config {
    security_group_ids = [aws_security_group.this.id]
    subnet_ids = [
      data.terraform_remote_state.common.outputs.vpc_subnet_1_id,
      data.terraform_remote_state.common.outputs.vpc_subnet_2_id,
    ]
  }

  tracing_config {
    mode = "Active"
  }
}

# ecc-aws-536 allowlist is stale (python3.9 etc.) and conflicts with 461 (python3.12)
resource "aws_lambda_function" "supported_runtime" {
  filename      = "func.zip"
  function_name = "${module.naming.resource_prefix.lambda_function}-536"
  role          = aws_iam_role.this.arn
  handler       = "func.lambda_handler"
  runtime       = "python3.9"
}
