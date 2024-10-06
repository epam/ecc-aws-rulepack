output "dynamodb_table" {
  value = {
    dynamodb-table = aws_dynamodb_table.this.arn
    ecc-aws-552-dynamodb_tables_unused = ["arn:aws:dynamodb:us-east-1:513731479296:table/autotest_dynamodb_table_red-2-DO-NOT-DELETE", "arn:aws:dynamodb:us-east-1:513731479296:table/autotest_dynamodb_table_red-3-DO-NOT-DELETE"]

  }
}
