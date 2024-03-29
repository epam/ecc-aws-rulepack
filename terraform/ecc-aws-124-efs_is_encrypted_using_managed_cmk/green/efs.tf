resource "aws_kms_key" "this" {
  description             = "124_kms_key_green"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "this" {
  name          = "alias/124_kms_key_green"
  target_key_id = aws_kms_key.this.key_id
}


resource "aws_efs_file_system" "this" {
  creation_token = "124_efs_green"
  encrypted      = true
  kms_key_id     = aws_kms_key.this.arn
}
