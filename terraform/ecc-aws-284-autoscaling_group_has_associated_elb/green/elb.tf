resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = aws_autoscaling_group.this.id
  elb                    = aws_elb.this.id
}

resource "aws_elb" "this" {
  name               = "elb-284-green"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  cross_zone_load_balancing = true
  idle_timeout              = 400

}

