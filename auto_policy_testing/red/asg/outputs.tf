output "asg" {
  value = {
    asg  = aws_autoscaling_group.this1.arn
    ecc-aws-072-autoscaling_group_health_checks = [aws_autoscaling_group.this2.arn, aws_autoscaling_group.this3.arn]
    ecc-aws-287-autoscaling_group_utilize_multi_az = [aws_autoscaling_group.this1.arn, aws_autoscaling_group.this2.arn]
    ecc-aws-395-auto_scaling_group_without_tag_information = aws_autoscaling_group.this2.arn
    ecc-aws-534-autoscaling_launch_template = aws_autoscaling_group.this2.arn

  }
}