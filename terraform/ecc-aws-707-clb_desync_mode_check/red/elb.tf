resource "aws_elb" "this" {
  name               = "elb-707-red"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  desync_mitigation_mode = "monitor"
  idle_timeout           = 400
}
