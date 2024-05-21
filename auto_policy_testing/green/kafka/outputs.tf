output "kafka" {
  value = {
    kafka = aws_msk_cluster.this.arn
  }
}
