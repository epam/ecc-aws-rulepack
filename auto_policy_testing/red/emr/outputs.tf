output "emr" {
  value = {
    emr = aws_emr_cluster.this1.arn
    ecc-aws-258-emr_at_rest_and_in_transit_encryption_enabled = [aws_emr_cluster.this1.arn, aws_emr_cluster.this2.arn]
  }
}
