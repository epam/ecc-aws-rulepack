resource "null_resource" "this" {
  provisioner "local-exec" {
    command     = "aws ec2 delete-key-pair --key-name ${aws_key_pair.this.key_name}"
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [aws_autoscaling_group.this]
}

resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "438_key_pair_red"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "aws_launch_template" "this" {
  name_prefix   = "438_launch_template_red"
  image_id      = data.aws_ami.this.id
  instance_type = "t2.micro"
  key_name      = "438_key_pair_red"
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
        key                 = "CsutodianRule"
        value               = "epam-aws-438-autoscaling_group_has_valid_configuration"
        propagate_at_launch = true
  }
	  
  tag {
        key                 = "ComplianceStatus"
        value               = "Red"
        propagate_at_launch = true
  }  

}
