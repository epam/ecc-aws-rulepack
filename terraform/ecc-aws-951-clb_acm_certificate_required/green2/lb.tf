resource "aws_elb" "this" {
  name               = "951-elb-http-green2"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
  }
}
