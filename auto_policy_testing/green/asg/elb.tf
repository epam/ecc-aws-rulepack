resource "aws_elb" "this" {
  name                        = "${module.naming.resource_prefix.lb}-1"
  subnets                     = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_2_id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_lb_target_group" "this" {
  name     = "${module.naming.resource_prefix.lb}-2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.common.outputs.vpc_id
}
