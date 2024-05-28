output "redshift" {
  value = {
    redshift = aws_redshift_cluster.this.cluster_identifier
  }
}
