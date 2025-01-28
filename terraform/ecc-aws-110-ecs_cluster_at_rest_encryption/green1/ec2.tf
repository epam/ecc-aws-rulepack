resource "aws_launch_template" "this" {
  name                                 = "110_launch-template_green1"
  image_id                             = data.aws_ami.this.id
  instance_type                        = "t3.nano"
  instance_initiated_shutdown_behavior = "terminate"
  user_data                            = base64encode("#!/bin/bash\necho ECS_CLUSTER=${local.cluster_name} >> /etc/ecs/ecs.config")
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_agent.name
  }
  network_interfaces {
    associate_public_ip_address = true
    device_index                = 0
    security_groups             = [data.aws_security_group.this.id]
    delete_on_termination       = true
  }
  placement {
    availability_zone = data.aws_availability_zones.this.names[0]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "110_ec2_instance_green1"
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name               = "110_autoscaling-group_green1"
  availability_zones = [data.aws_availability_zones.this.names[0]]
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  lifecycle {
    create_before_destroy = true
  }
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
  tag {
    key                 = "CustodianRule"
    value               = "ecc-aws-110-ecs_cluster_at_rest_encryption"
    propagate_at_launch = true
  }
  tag {
    key                 = "ComplianceStatus"
    value               = "Green1"
    propagate_at_launch = true
  }
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
