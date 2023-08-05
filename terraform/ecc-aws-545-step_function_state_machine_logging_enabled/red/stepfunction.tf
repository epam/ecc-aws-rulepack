resource "aws_sfn_state_machine" "this" {
  name     = "state-machine-545-red"
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