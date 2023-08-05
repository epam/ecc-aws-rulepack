resource "aws_dynamodb_table" "this" {
  name         = "183_dynamodb_table_red"
  hash_key     = "RedTableHashKey"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "RedTableHashKey"
    type = "S"
  }
}