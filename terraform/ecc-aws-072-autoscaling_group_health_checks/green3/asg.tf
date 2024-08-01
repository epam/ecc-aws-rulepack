resource "aws_launch_template" "this" {
  name_prefix   = "072_launch_template_green3"
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
  name                = "072-asg-green3"
  availability_zones        = [data.aws_availability_zones.this.names[0]]
  desired_capacity          = 0
  max_size                  = 0
  min_size                  = 0
  health_check_type         = "ELB"
  target_group_arns   = [ aws_lb_target_group.this.arn ]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  tag {
    key                 = "CustodianRule"
    value               = "ecc-aws-072-autoscaling_group_health_checks"
    propagate_at_launch = true
  }

  tag {
    key                 = "ComplianceStatus"
    value               = "Green"
    propagate_at_launch = true
  }
}

resource "aws_lb_target_group" "this" {
  name     = "072-target-group-green3"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.this.id
  
}

data "aws_vpc" "this" {
  default = true
}

data "aws_availability_zones" "this" {
  state = "available"
}