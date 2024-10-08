resource "aws_dynamodb_table" "this" {
  name           = module.naming.resource_prefix.dynamodb_table
  hash_key       = "GreenTableHashKey"
  billing_mode   = "PROVISIONED"
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

# Tables created for rule ecc-aws-552-dynamodb_tables_unused
# Table must be older than 60 days for this rule to work
# Do not uncomment these lines, uncomment them only if you need to remove tables

# resource "aws_dynamodb_table" "this2" {
#   name           = "${module.naming.resource_prefix.dynamodb_table}-2-DO-NOT-DELETE"
#   hash_key       = "GreenTableHashKey"
#   billing_mode   = "PROVISIONED"
#   read_capacity  = 1
#   write_capacity = 1

#   attribute {
#     name = "GreenTableHashKey"
#     type = "S"
#   }
# }

# resource "aws_dynamodb_table" "this3" {
#   name           = "${module.naming.resource_prefix.dynamodb_table}-3-DO-NOT-DELETE"
#   hash_key       = "GreenTableHashKey"
#   billing_mode   = "PROVISIONED"
#   read_capacity  = 1
#   write_capacity = 1

#   attribute {
#     name = "GreenTableHashKey"
#     type = "S"
#   }
# } 
# resource "aws_dynamodb_table_item" "this2" {
#   table_name = aws_dynamodb_table.this2.name
#   hash_key   = aws_dynamodb_table.this2.hash_key

#   item = <<ITEM
# {
#   "GreenTableHashKey": {"S": "something"},
#   "one": {"N": "11111"},
#   "two": {"N": "22222"},
#   "three": {"N": "33333"},
#   "four": {"N": "44444"}
# }
# ITEM
# }