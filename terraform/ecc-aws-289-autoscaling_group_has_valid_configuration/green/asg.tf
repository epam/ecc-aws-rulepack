resource "aws_launch_template" "this" {
  name_prefix   = "289_launch_template_green"
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
  name                = "289-autoscaling_group-green"
  vpc_zone_identifier = [aws_subnet.this.id, aws_subnet.this1.id]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
        key                 = "CustodianRule"
        value               = "ecc-aws-289-autoscaling_group_has_valid_configuration"
        propagate_at_launch = true
  }
	  
  tag {
        key                = "ComplianceStatus"
        value               = "Green"
        propagate_at_launch = true
  }

}