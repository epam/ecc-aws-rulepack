resource "aws_launch_configuration" "this" {
  name_prefix   = "950_launch_configuration_red"
  image_id      = data.aws_ami.this.id
  instance_type = "t2.micro"
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = "5"
  }
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_autoscaling_group" "this" {
  availability_zones        = ["us-east-1a"]
  desired_capacity          = 0
  max_size                  = 0
  min_size                  = 0
  health_check_grace_period = 300
  health_check_type         = "ELB"
  launch_configuration      = aws_launch_configuration.this.id
}