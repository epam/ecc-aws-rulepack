output "app-elb" {
  value = {
    app-elb = aws_lb.this1.arn
    ecc-aws-010-http_elb_certificate_expire_in_one_week = [aws_lb.this1.arn, aws_lb.this2.arn]
    ecc-aws-011-http_elb_certificate_expire_in_one_month = [aws_lb.this1.arn, aws_lb.this2.arn]
    ecc-aws-129-enable_elb_access_logs = [aws_lb.this1.arn, aws_lb.this2.arn]
    ecc-aws-130-update_security_policy_of_network_load_balancer = aws_lb.this2.arn
    ecc-aws-194-elb_deletion_protection_enabled = [aws_lb.this1.arn, aws_lb.this2.arn, aws_lb.this3.arn]
    ecc-aws-498-elbv2_multiple_az = [aws_lb.this2.arn, aws_lb.this3.arn]
    ecc-aws-512-elb_internet_facing = [aws_lb.this1.arn, aws_lb.this2.arn]
  }
}
