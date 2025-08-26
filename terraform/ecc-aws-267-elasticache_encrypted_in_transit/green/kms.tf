resource "aws_kms_key" "this" {
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "this" {
  name          = "alias/key-125-green"
  target_key_id = aws_kms_key.this.key_id
}