resource "aws_sfn_state_machine" "this" {
  name     = "state-machine-545-green"
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

  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.this.arn}:*"
    include_execution_data = true
    level                  = "ERROR"
  }
}