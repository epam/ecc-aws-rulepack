data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_elb" "this" {
  name            = "clb-553-green"
  subnets         = [data.aws_subnets.this.ids[0]]
  security_groups = ["${aws_security_group.this.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  instances = ["${aws_instance.this.id}"]
}
