output "codedeploy" {
  value = {
    codedeploy-group  = aws_codedeploy_deployment_group.this1.deployment_group_id
    ecc-aws-484-codedeploy_auto_rollback_monitor_enabled = [aws_codedeploy_deployment_group.this1.deployment_group_id, aws_codedeploy_deployment_group.this2.deployment_group_id, aws_codedeploy_deployment_group.this3.deployment_group_id]
    ecc-aws-485-codedeploy_ec2_minimum_healthy_hosts_configured = [aws_codedeploy_deployment_group.this4.deployment_group_id, aws_codedeploy_deployment_group.this5.deployment_group_id, aws_codedeploy_deployment_group.this6.deployment_group_id]
    ecc-aws-484-codedeploy_auto_rollback_monitor_enabled = [aws_codedeploy_deployment_group.this1.deployment_group_id]#, aws_codedeploy_deployment_group.this2.deployment_group_id]
  }
}
