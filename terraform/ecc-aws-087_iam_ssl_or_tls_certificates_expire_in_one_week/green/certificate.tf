###### The step to be done before run infrastructure is to run command below
# sudo openssl req -x509 -nodes -days 8 -newkey rsa:2048 -keyout private.key -out certificate.crt 

resource "aws_iam_server_certificate" "this" {
  name             = "087_certificate_green"
  certificate_body = file("certificate.crt")
  private_key      = file("private.key")
}
