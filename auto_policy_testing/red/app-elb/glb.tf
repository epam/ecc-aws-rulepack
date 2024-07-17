resource "aws_lb" "glb" {
  name               = "${module.naming.resource_prefix.lb}-gateway-1"
  internal           = false
  load_balancer_type = "gateway"
  subnets            = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id]
}
