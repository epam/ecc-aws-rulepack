output "redshift" {
  value = {
    redshift                                            = aws_redshift_cluster.this1.cluster_identifier
    ecc-aws-164-redshift_clusters_audit_logging_enabled = [aws_redshift_cluster.this1.cluster_identifier, aws_redshift_cluster.this2.cluster_identifier]
  }
}
