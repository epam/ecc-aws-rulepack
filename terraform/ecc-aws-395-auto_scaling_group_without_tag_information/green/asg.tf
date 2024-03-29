resource "aws_launch_template" "this" {
  name_prefix   = "395_launch_template_green"
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
  name               = "395-autoscaling_group-green"
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  
  tag {
    key                 = "CustodianRule"
    value               = "ecc-aws-395-auto_scaling_group_without_tag_information"
    propagate_at_launch = true
  }
	  
  tag {
    key                 = "ComplianceStatus"
    value               = "Green"
    propagate_at_launch = true
  }
}