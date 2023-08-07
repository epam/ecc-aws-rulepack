########################
###   WARNING !!!    ###
# This is a very expensive resource. Each WorkSpace will cost $7.25/month + $0.17/hour.


# To create an UNHEALTHY WorkSpace, you can change hostname of the workstation. In order to do this:
# 1) Connect to a workstation (https://docs.aws.amazon.com/workspaces/latest/adminguide/getting-started.html#quick-setup-connect-workspace) 
# 2) Type the following command to edit /etc/hostname:
#    sudo vi /etc/hostname 
# 3) Setup a new name.
# 4) Reboot the system to changes take effect.
# After these steps, WorkSpaces will start rebooting process. 
# After some time, Amazon WorkSpaces console will show status UNHEALTHY, and you won't be able to connect to WorkSpace.
# Then you can destroy infrastructure.

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
  user_name    = "Admin"

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