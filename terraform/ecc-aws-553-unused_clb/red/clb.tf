data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_elb" "this" {
  name               = "clb-553-red"
  availability_zones = data.aws_availability_zones.this.names

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}
