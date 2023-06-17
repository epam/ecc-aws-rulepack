resource "aws_sns_topic" "this" {
  name              = "rule-368-green"
  kms_master_key_id = "alias/aws/sns"
}