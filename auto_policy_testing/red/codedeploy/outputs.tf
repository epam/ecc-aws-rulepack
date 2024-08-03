output "codedeploy" {
  value = {
    codedeploy  = aws_codedeploy_deployment_group.this1.arn
    ecc-aws-484-codedeploy_auto_rollback_monitor_enabled = [aws_codedeploy_deployment_group.this1.arn, aws_codedeploy_deployment_group.this2.arn, aws_codedeploy_deployment_group.this3.arn]
    ecc-aws-485-codedeploy_ec2_minimum_healthy_hosts_configured = [aws_codedeploy_deployment_group.this4.arn, aws_codedeploy_deployment_group.this5.arn, aws_codedeploy_deployment_group.this6.arn]
    ecc-aws-484-codedeploy_auto_rollback_monitor_enabled = [aws_codedeploy_deployment_group.this1.arn]#, aws_codedeploy_deployment_group.this2.arn]
  }
}
