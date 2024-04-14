resource "aws_network_interface" "this" {
  subnet_id = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
}
