resource "aws_autoscaling_group" "this2" {
  name                = "${module.naming.resource_prefix.ec2}-asg-2"
  availability_zones  = [
    data.terraform_remote_state.common.outputs.az_subnet_pub_1.az_name, 
    data.terraform_remote_state.common.outputs.az_subnet_pub_2.az_name
    ]
  desired_capacity    = 0
  max_size            = 1
  min_size            = 0
  target_group_arns   = [ aws_lb_target_group.this.arn ]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
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