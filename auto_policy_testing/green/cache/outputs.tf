output "cache" {
  value = {
    cache-cluster = aws_elasticache_cluster.this.arn
  }
}