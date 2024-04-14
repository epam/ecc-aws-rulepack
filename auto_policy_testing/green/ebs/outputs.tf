output "ebs" {
  value = {
    ebs                                           = aws_ebs_volume.this.id
    ebs-snapshot                                  = aws_ebs_snapshot.this.id
    ecc-aws-326-ebs_volume_encrypted_with_kms_cmk = aws_ebs_volume.volume_encrypted_with_kms_cmk.id
  }
}
