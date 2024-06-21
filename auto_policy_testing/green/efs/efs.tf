resource "aws_efs_file_system" "this" {
  creation_token         = "${module.naming.resource_prefix.efs}"
  encrypted              = true
  kms_key_id             = data.terraform_remote_state.common.outputs.kms_key_arn
  availability_zone_name = data.terraform_remote_state.common.outputs.az_subnet_pub_1.az_name

  lifecycle_policy {
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }
  lifecycle_policy {
    transition_to_ia                    = "AFTER_30_DAYS"
  }

  tags = {
    Name = "${module.naming.resource_prefix.efs}"
  }
}

resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.this.id

  backup_policy {
    status = "ENABLED"
  }
}

resource "aws_efs_mount_target" "this" {
  file_system_id         = aws_efs_file_system.this.id
  subnet_id              = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
  # availability_zone_name = data.aws_availability_zones.this.names[0]
}
