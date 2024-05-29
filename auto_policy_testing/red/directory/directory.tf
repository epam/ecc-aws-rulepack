
resource "aws_directory_service_directory" "this" {
  name     = "${module.naming.resource_prefix.directory}.com"
  password = "#S1ncerely"
  size     = "Small"

  vpc_settings {
    vpc_id = data.terraform_remote_state.common.outputs.vpc_id
    subnet_ids = [
      data.terraform_remote_state.common.outputs.vpc_subnet_1_id,
      data.terraform_remote_state.common.outputs.vpc_subnet_3_id
    ]
  }
}
