resource "aws_lambda_function" "this" {
  filename         = "lambda_function.zip"
  function_name    = "366_lambda_function_red"
  role             = aws_iam_role.this.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime          = "python3.7"

}

resource "aws_lambda_permission" "this" {
  function_name = aws_lambda_function.this.function_name
  statement_id  = "AllowExecutionSecretManager"
  action        = "lambda:InvokeFunction"
  principal     = "secretsmanager.amazonaws.com"
}

resource "aws_iam_role" "this" {
  name = "366_iam_role_red"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "lambda:GetFunction",
      "lambda:InvokeAsync",
      "lambda:InvokeFunction"]

    resources = [
      "arn:aws:lambda:::*",
    ]
  }
}

resource "aws_iam_role_policy" "this" {
  name   = "366_iam_role_policy_red"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this.json
}