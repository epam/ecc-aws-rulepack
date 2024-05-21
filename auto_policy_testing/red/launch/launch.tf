resource "aws_launch_configuration" "this" {
  name_prefix                 = "${module.naming.resource_prefix.launch_config}"
  image_id                    = data.aws_ami.this.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true 

  # metadata_options {
  #   http_endpoint               = "enabled"
  #   http_tokens                 = "required"
  #   http_put_response_hop_limit = "5"
  # }
}

resource "aws_launch_configuration" "this2" {
  name_prefix                 = "${module.naming.resource_prefix.launch_config}-2"
  image_id                    = data.aws_ami.this.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true 

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = "5"
  }
}