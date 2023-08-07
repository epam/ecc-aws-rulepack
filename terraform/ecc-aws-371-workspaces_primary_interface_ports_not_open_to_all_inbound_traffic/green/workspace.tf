########################
###   WARNING !!!    ###
# This is a very expensive resource. Each WorkSpace will cost $7.25/month + $0.17/hour.

/*
To attach created security groups:
1. Go to https://us-east-1.console.aws.amazon.com/workspaces/home?region=us-east-1#directories:directories
2. Note VPC of the created Directory
3. Go to https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#NIC:
4. Filter network interfaces using noted VPC ID.
5. Select the Network interface which has the following description "Created By Amazon Workspaces for AWS Account ID"
6. Click "Actions" and "Change security groups".
7. Attach security groups that start with "workstation_security_group". Click "Add security group".
8. Click "Save".
*/

data "aws_workspaces_bundle" "this" {
  bundle_id = "wsb-8pmj7b7pq" 
}

resource "aws_directory_service_directory" "this" {
  name     = "workspaces.example.com"
  password = "#S1ncerely"
  size = "Small"

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

  workspace_properties {
    compute_type_name                         = "STANDARD"
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



