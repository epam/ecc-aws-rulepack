resource "aws_iam_role" "this" {
  name = module.naming.resource_prefix.iam_role

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

resource "aws_iam_role_policy" "this1" {
  name   = "${module.naming.resource_prefix.iam_policy}-1"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this1.json
}

resource "aws_iam_role_policy_attachment" "this1" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}