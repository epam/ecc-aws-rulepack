resource "aws_launch_configuration" "this" {
  name_prefix   = "${module.naming.resource_prefix.launch_config}"
  image_id      = data.aws_ami.this.id
  instance_type = "t4g.nano"
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = "5"
  }
}

resource "aws_autoscaling_group" "this2" {
  name                = "${module.naming.resource_prefix.ec2}-asg-2"
  availability_zones = [
    data.terraform_remote_state.common.outputs.az_subnet_pub_1.az_name
    ]
  capacity_rebalance  = false
  desired_capacity    = 0
  max_size            = 1
  min_size            = 0
  load_balancers = [aws_elb.this.name]
  launch_configuration = aws_launch_configuration.this.name
}