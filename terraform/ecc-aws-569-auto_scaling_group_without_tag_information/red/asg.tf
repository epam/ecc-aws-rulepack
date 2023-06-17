resource "aws_launch_template" "this" {
  name_prefix   = "569_launch_template_red"
  image_id      = data.aws_ami.this.id
  instance_type = "t2.micro"

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
  name               = "569-autoscaling_group-red"
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1


  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}