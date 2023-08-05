resource "aws_sns_topic" "this" {
  name              = "rule-352-red"
  kms_master_key_id = "alias/aws/sns"
}