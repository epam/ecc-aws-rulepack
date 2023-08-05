########################
###   WARNING !!!    ###
# This is a very expensive resource. Each WorkSpace will cost $7.25/month + $0.17/hour.


data "aws_workspaces_bundle" "this" {
  bundle_id = "wsb-8pmj7b7pq" 
}

resource "aws_directory_service_directory" "this" {
  name     = "workspaces.example.com"
  password = "#S1ncerely"
  size     = "Small"

  vpc_settings {
    vpc_id     = aws_vpc.this.id
    subnet_ids = [aws_subnet.this1.id, aws_subnet.this2.id]
  }
}

resource "aws_workspaces_directory" "this" {
  directory_id = aws_directory_service_directory.this.id
  subnet_ids   = [aws_subnet.this1.id, aws_subnet.this2.id]

  depends_on = [
    aws_iam_role_policy_attachment.workspaces-default-service-access,
    aws_iam_role_policy_attachment.workspaces-default-self-service-access
  ]
}

resource "aws_workspaces_workspace" "this" {
  directory_id = aws_workspaces_directory.this.id
  bundle_id    = data.aws_workspaces_bundle.this.id
  user_name    = "Administrator"

  root_volume_encryption_enabled = true
  user_volume_encryption_enabled = true
  volume_encryption_key = aws_kms_key.this.arn

  workspace_properties {
    compute_type_name                         = "VALUE"
    user_volume_size_gib                      = 10
    root_volume_size_gib                      = 80
    running_mode                              = "AUTO_STOP"
    running_mode_auto_stop_timeout_in_minutes = 60
  }

  depends_on = [
    aws_iam_role_policy_attachment.workspaces-default-service-access,
    aws_workspaces_directory.this
  ]
}

resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt WorkSpaces"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
  is_enabled              = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/WorkSpacesKey"
  target_key_id = aws_kms_key.this.key_id
}