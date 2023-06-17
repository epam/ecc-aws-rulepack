resource "null_resource" "this" {

  provisioner "local-exec" {
    command = "aws securityhub disable-security-hub"
    interpreter = ["/bin/bash", "-c"]
  }
}
