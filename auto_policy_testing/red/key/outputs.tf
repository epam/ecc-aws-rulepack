output "key" {
  value = {
    key-pair = aws_key_pair.this.key_pair_id
    kms-key  = aws_kms_key.this.arn
  }
}
