resource "aws_elb" "this" {
  name               = "elb-708-red"
  availability_zones = ["us-east-1a"]

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}
