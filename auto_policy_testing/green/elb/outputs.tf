output "elb" {
  value = {
    elb                                     = aws_elb.this1.arn
    ecc-aws-013-remove_weak_ciphers_for_clb = [aws_elb.this1.arn, aws_elb.this2.arn]
  }
}
