resource "aws_launch_template" "this" {
  name_prefix   = "471_launch_template_green"
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
  name                = "471-autoscaling_group-green"
  availability_zones  = ["us-east-1a"]
  capacity_rebalance  = true
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 25
      spot_allocation_strategy                 = "capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this.id
        version = "$Latest"
      }

      override {
        instance_type     = "t2.nano"
        weighted_capacity = "3"
      }

      override {
        instance_type     = "t2.small"
        weighted_capacity = "2"
      }
    }
  }

  tag {
    key                 = "CustodianRule"
    value               = "ecc-aws-471-autoscaling_groups_capacity_rebalancing_enabled"
    propagate_at_launch = true
  }

  tag {
    key                 = "ComplianceStatus"
    value               = "Green"
    propagate_at_launch = true
  }
}