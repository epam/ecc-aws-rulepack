resource "aws_iam_server_certificate" "this" {
  name             = "535_server_certificate_red"
  certificate_body = data.local_file.this2.content
  private_key      = data.local_file.this1.content

  depends_on = [local_file.this1, local_file.this2]
}

resource "local_file" "this1" {
    source  = "private.key"
    filename = "private.key"
    depends_on = [null_resource.this]
}

resource "local_file" "this2" {
    source  = "certificate.crt"
    filename = "certificate.crt"
    depends_on = [null_resource.this]
}

data "local_file" "this1" {
    filename = "private.key"
    depends_on = [local_file.this1, local_file.this2]
}

data "local_file" "this2" {
    filename = "certificate.crt"
    depends_on = [local_file.this1, local_file.this2]
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "openssl req -x509 -nodes -days 1 -newkey rsa:2048 -keyout private.key -out certificate.crt -subj '/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=example.com'"
    interpreter = ["/bin/bash", "-c"]
  }
}