resource "aws_sns_topic" "this" {
  name              = "rule-516-red"
  kms_master_key_id = "alias/aws/sns"
}