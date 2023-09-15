resource "aws_dynamodb_table" "this" {
  name         = "552_dynamodb_table_red"
  hash_key     = "GreenTableHashKey"
  billing_mode = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1


  attribute {
    name = "GreenTableHashKey"
    type = "S"
  }
}
