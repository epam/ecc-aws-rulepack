resource "aws_elasticache_cluster" "this" {
  cluster_id               = "c7n-266-elasticache-cluster-green"
  engine                   = "redis"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 6379
  snapshot_retention_limit = 7
}
