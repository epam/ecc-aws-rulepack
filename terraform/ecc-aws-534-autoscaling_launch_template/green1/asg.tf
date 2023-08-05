resource "aws_launch_template" "this" {
  name_prefix   = "534_launch_template_green1"
  image_id      = data.aws_ami.this.id
  instance_type = "t2.nano"
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
  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this.id
      }
    }
  }
}