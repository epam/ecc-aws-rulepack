/* run 'terraform apply'
Go to the Directory Service.
Select the created with teraform Directory
Go to the buttom of the page, go to the 'Multi-factor authentication'
Click 'Actions', 'Enable'
Display label = 373_mfa_label
RADIUS server DNS name or IP addresses = 127.0.0.1
Protocol = CHAP
*/

resource "aws_directory_service_directory" "this" {
  name     = "workspaces.373RadiusServerRed.com"
  password = "#S1ncerely"
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = aws_vpc.this.id
    subnet_ids = [aws_subnet.this1.id, aws_subnet.this2.id]
  }
}

resource "aws_workspaces_directory" "this" {
  directory_id = aws_directory_service_directory.this.id
  subnet_ids   = [aws_subnet.this1.id, aws_subnet.this2.id]
  # depends_on = [
  #   aws_iam_role_policy_attachment.workspaces-default-service-access,
  #   aws_iam_role_policy_attachment.workspaces-default-self-service-access
  # ]

}
