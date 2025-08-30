# takes ~30 minutes to create the directory
# takes ~10 minutes to delete the directory

resource "aws_directory_service_directory" "this" {
  name     = "workspaces.373RadiusServerGreen.com"
  password = "#S1ncerely"
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = aws_vpc.this.id
    subnet_ids = [aws_subnet.this1.id, aws_subnet.this2.id]
  }
}

resource "null_resource" "radius_settings" {
  provisioner "local-exec" {
    command = <<-EOT
      aws ds enable-radius \
        --directory-id ${aws_directory_service_directory.this.id} \
        --radius-settings '{
          "RadiusServers": ["127.0.0.1"],
          "RadiusPort": 1812,
          "RadiusTimeout": 1,
          "RadiusRetries": 4,
          "AuthenticationProtocol": "MS-CHAPv2",
          "DisplayLabel": "373_mfa_label",
          "SharedSecret": "12345678"
        }' \
        --region us-east-1 || true
    EOT
    
    on_failure = continue
  }

  depends_on = [aws_directory_service_directory.this]
  
  triggers = {
    directory_id = aws_directory_service_directory.this.id
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
