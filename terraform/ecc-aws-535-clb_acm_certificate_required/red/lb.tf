resource "aws_elb" "this" {
  name               = "535-elb-http-red"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  
  listener {
    instance_port      = 8000
    instance_protocol  = "tcp"
    lb_port            = 443
    lb_protocol        = "ssl"
    ssl_certificate_id = aws_iam_server_certificate.this.arn
  }
}
