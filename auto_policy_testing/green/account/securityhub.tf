resource "null_resource" "this" {

  provisioner "local-exec" {
    command = "aws securityhub enable-security-hub  --no-enable-default-standards"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws securityhub disable-security-hub"
  }
}