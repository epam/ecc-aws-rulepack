resource "null_resource" "this" {

  provisioner "local-exec" {
    command = "aws securityhub enable-security-hub --enable-default-standards"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws securityhub disable-security-hub"
    interpreter = ["/bin/bash", "-c"]
  }

}