# In order to create red infrastructure manual steps are required.
# 1. Before running 'terraform apply' create key pair using a 'ssh-keygen -f ~/key_pair -m PEM' command.
# 2. Run 'terraform apply'.
# 3. Go to https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs and delete '438_key_pair_red' key pair.
# 4. Run custodian policy.


resource "aws_key_pair" "this" {
  key_name   = "438_key_pair_red"
  public_key = file("${path.module}/key_pair.pub")
}

resource "aws_launch_template" "this" {
  name_prefix   = "438_launch_template_red"
  image_id      = data.aws_ami.this.id
  instance_type = "t2.micro"
  key_name = "438_key_pair_red"
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name = "name"
	values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_autoscaling_group" "this" {
  name               = "438-autoscaling_group-red"
  vpc_zone_identifier = [aws_subnet.this.id]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  
  tag {
        key                 = "CustodianRule"
        value               = "ecc-aws-438-autoscaling_group_has_valid_configuration"
        propagate_at_launch = true
  }
	  
  tag {
        key                 = "ComplianceStatus"
        value               = "Red"
        propagate_at_launch = true
  }  

}
