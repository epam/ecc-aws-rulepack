output "dynamodb_table" {
  value = {
    dynamodb-table = aws_dynamodb_table.this1.arn
    ecc-aws-182-dynamodb_tables_autoscaling_enabled = [aws_dynamodb_table.this1.arn, aws_dynamodb_table.this2.arn]
  }
}
