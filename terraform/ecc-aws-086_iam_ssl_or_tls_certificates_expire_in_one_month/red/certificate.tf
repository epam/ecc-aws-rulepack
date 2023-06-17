###### The step to be done before run infrastructure is to run command below
# sudo openssl req -x509 -nodes -days 20 -newkey rsa:2048 -keyout second-private.key -out second-certificate.crt 

resource "aws_iam_server_certificate" "this" {
  name             = "086_certificate_red"
  certificate_body = file("certificate.crt")
  private_key      = file("private.key")
}
