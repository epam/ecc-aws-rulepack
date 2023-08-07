resource "null_resource" "this" {
  provisioner "local-exec" {
    command     = "echo -e '\\n\\n\\n\\n\\n\\n\\n\\n' | openssl req -x509 -nodes -days 20 -newkey rsa:2048 -keyout private.key -out certificate.crt"
    interpreter = ["/bin/bash", "-c"]
  }
}

data "local_file" "certificate" {
  filename = "certificate.crt"
  depends_on = [null_resource.this]
}

data "local_file" "private_key" {
  filename = "private.key"
  depends_on = [null_resource.this]
}

resource "aws_iam_server_certificate" "this" {
  name             = "008_certificate_green"
  certificate_body = data.local_file.certificate.content
  private_key      = data.local_file.private_key.content
}