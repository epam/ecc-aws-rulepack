output "elb" {
  value = {
    elb                                     = aws_elb.this1.name
    ecc-aws-013-remove_weak_ciphers_for_clb = [aws_elb.this1.name, aws_elb.this2.name]
    ecc-aws-014-clb_uses_https              = [aws_elb.this3.name]
    ecc-aws-553-unused_clb                  = [aws_elb.this3.name]
  }
}
