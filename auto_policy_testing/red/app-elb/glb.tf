resource "aws_lb" "this3" {
  name               = "${module.naming.resource_prefix.lb}-gw-1"
  load_balancer_type = "gateway"
  subnets            = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id]#, data.terraform_remote_state.common.outputs.vpc_subnet_2_id ]
}
