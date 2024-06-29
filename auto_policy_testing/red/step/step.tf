resource "aws_sfn_state_machine" "this" {
  name     = "${module.naming.resource_prefix.step_function}"
  role_arn = aws_iam_role.sfn.arn

  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "HelloWorld",
  "States": {
    "HelloWorld": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.this.arn}",
      "End": true
    }
  }
}
EOF
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${module.naming.resource_prefix.step_function}-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role" "sfn" {
  name               = "${module.naming.resource_prefix.step_function}-sfn"
  assume_role_policy = data.aws_iam_policy_document.sfn.json
}

resource "aws_iam_role_policy" "sfn_role_policy" {
  name   = "${module.naming.resource_prefix.step_function}"
  role   = aws_iam_role.sfn.id
  policy = data.aws_iam_policy_document.sfn_policy.json
}


resource "aws_lambda_function" "this" {
  function_name    = "${module.naming.resource_prefix.step_function}"
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "welcome.lambda_handler"
  runtime          = "python3.9"
}
