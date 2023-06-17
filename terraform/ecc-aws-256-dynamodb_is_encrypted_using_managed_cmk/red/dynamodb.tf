resource "aws_dynamodb_table" "this" {
  name             = "256_dynamodb_table_red"
  hash_key         = "RedTableHashKey"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "RedTableHashKey"
    type = "S"
  }
}