resource "aws_launch_template" "this" {
  name                                 = "${module.naming.resource_prefix.ec2}"
  image_id                             = data.aws_ami.this.id
  instance_type                        = "t2.micro"
  instance_initiated_shutdown_behavior = "terminate"
  user_data                            = base64encode("#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.this2.name} >> /etc/ecs/ecs.config")
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      volume_size           = 30
      volume_type           = "gp2"
      encrypted             = true
    }
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs-agent.name
  }
  network_interfaces {
    associate_public_ip_address = true
    device_index                = 0
    security_groups             = [aws_security_group.this.id]
    delete_on_termination       = true
    subnet_id = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
  }
  placement {
    availability_zone = data.terraform_remote_state.common.outputs.az_subnet_pub_1.az_name
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${module.naming.resource_prefix.ec2}"
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name               = "${module.naming.resource_prefix.ec2}-asg"
  availability_zones = [data.terraform_remote_state.common.outputs.az_subnet_pub_1.az_name]
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  lifecycle {
    create_before_destroy = true
  }
  desired_capacity          = 1
  min_size                  = 0
  max_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

resource "null_resource" "cleanup_asg" {
  depends_on = [
    aws_autoscaling_group.this
  ]
  triggers = {
    asg = aws_autoscaling_group.this.name
  }
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
set +x
aws autoscaling update-auto-scaling-group --auto-scaling-group-name ${self.triggers.asg} --min-size 0 --desired-capacity 0
EOF
  }
}
