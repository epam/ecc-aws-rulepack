resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = module.naming.resource_prefix.kms_key
  public_key = tls_private_key.rsa.public_key_openssh
}


resource "aws_launch_template" "this" {
  name_prefix   = "${module.naming.resource_prefix.launch_template}"
  image_id      = data.aws_ami.this.id
  instance_type = "t4g.nano"
  key_name      = aws_key_pair.this.key_name
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

resource "aws_autoscaling_group" "this1" {
  name                = "${module.naming.resource_prefix.ec2}-asg-1"
  vpc_zone_identifier = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_2_id]
  capacity_rebalance  = true
  desired_capacity    = 0
  max_size            = 1
  min_size            = 0
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers = [aws_elb.this.name]

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 25
      spot_allocation_strategy                 = "lowest-price"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this.id
        version = "$Latest"
      }

      override {
        instance_type     = "t4g.micro"
        weighted_capacity = "3"
      }

      override {
        instance_type     = "t4g.nano"
        weighted_capacity = "2"
      }
    }
  }

 tag {
        key                 = "ResourceType"
        value               = "asg"
        propagate_at_launch = false
  }
	  
  tag {
        key                = "ComplianceStatus"
        value               = "green"
        propagate_at_launch = true
  } 
  tag {
        key                = "Owner"
        value               = "c7n-ci"
        propagate_at_launch = true
  } 
}