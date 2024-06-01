output "emr" {
  value = {
    emr = aws_emr_cluster.this.arn
  }
}
