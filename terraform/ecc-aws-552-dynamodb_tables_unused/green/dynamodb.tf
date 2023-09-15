resource "aws_dynamodb_table" "this" {
  name         = "552_dynamodb_table_green"
  hash_key     = "GreenTableHashKey"
  billing_mode = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1


  attribute {
    name = "GreenTableHashKey"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "this" {
  table_name = aws_dynamodb_table.this.name
  hash_key   = aws_dynamodb_table.this.hash_key

  item = <<ITEM
{
  "GreenTableHashKey": {"S": "something"},
  "one": {"N": "11111"},
  "two": {"N": "22222"},
  "three": {"N": "33333"},
  "four": {"N": "44444"}
}
ITEM
}