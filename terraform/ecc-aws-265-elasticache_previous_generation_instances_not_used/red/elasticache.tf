# 26.04.2022 Terraform cannot launch ElastiCache Cache Cluster with previous generation node type
resource "aws_elasticache_cluster" "redis" {
  cluster_id               = "c7n-265-elasticache-redis-cluster-red"
  engine                   = "redis"
  engine_version           = "5.0.6"
  node_type                = "cache.m3.medium"
  num_cache_nodes          = 1
  port                     = 6379
}