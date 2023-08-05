resource "aws_launch_configuration" "this" {
  name_prefix                 = "364_launch_configuration_red"
  image_id                    = data.aws_ami.this.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name = "name"
	values = ["amzn2-ami-hvm*"]
  }
}