# Removing this resource from Terraform has no effect to the encryption configuration within X-Ray.
resource "aws_xray_encryption_config" "this" {
  type   = "KMS"
  key_id = data.terraform_remote_state.common.outputs.kms_key_arn
}

resource "null_resource" "disable_xray_encryption" {
  provisioner "local-exec" {
    when    = destroy
    command = "aws xray put-encryption-config --type NONE"
  }

  depends_on = [aws_xray_encryption_config.this]
}