resource "aws_autoscaling_group" "this3" {
  name                = "${module.naming.resource_prefix.ec2}-asg-3"
  availability_zones = [
    data.terraform_remote_state.common.outputs.az_subnet_pub_1.az_name
    ]
  capacity_rebalance  = false
  desired_capacity    = 0
  max_size            = 1
  min_size            = 0
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}