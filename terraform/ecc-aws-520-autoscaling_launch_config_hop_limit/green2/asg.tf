resource "aws_launch_configuration" "this" {
  name_prefix                 = "520_launch_configuration_green2"
  image_id                    = data.aws_ami.this.id
  instance_type               = "t2.micro"
  metadata_options {
    http_endpoint               = "disabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = "5"
  }
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name = "name"
	values = ["amzn2-ami-hvm*"]
  }
}
