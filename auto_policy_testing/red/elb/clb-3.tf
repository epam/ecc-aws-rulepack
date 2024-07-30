resource "aws_elb" "this3" {
  name            = "${module.naming.resource_prefix.lb}-3"
  subnets         = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id]
  security_groups = ["${aws_security_group.this1.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

}
