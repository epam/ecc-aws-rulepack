output "cache" {
  value = {
    cache-cluster                              = "arn:aws:elasticache:${var.region}:${data.aws_caller_identity.this.account_id}:cluster:${tolist(aws_elasticache_replication_group.this.member_clusters)[0]}"
    ecc-aws-266-elasticache_automatic_backups  = aws_elasticache_cluster.backups_logs.arn
    ecc-aws-453-elasticache_redis_logs_enabled = aws_elasticache_cluster.backups_logs.arn
  }
}