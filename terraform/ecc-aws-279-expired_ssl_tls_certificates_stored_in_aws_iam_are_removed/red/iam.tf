###### The step to be done before run infrastructure is to run command below
# openssl req -x509 -nodes -days 1 -newkey rsa:2048 -keyout second-private.key -out second-certificate.crt - ### we can't create expired certificate
resource "aws_iam_server_certificate" "this" {
  name             = "279_server_certificate_red"
  certificate_body = file("certificate.crt")
  private_key      = file("private.key")
}
