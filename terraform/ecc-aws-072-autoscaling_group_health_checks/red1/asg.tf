resource "aws_launch_template" "this" {
  name_prefix   = "072_launch_template_red1"
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
  name                = "072_asg_red1"
  availability_zones        = [data.aws_availability_zones.this.names[0]]
  desired_capacity          = 0
  max_size                  = 0
  min_size                  = 0
  load_balancers = [aws_elb.this.name]

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
    value               = "Red"
    propagate_at_launch = true
  }
}

resource "aws_elb" "this" {
  name                        = "072-elb-red1"
  subnets                     = [data.aws_subnets.this.ids[0]]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}