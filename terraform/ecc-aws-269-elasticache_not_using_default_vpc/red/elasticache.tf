resource "aws_elasticache_cluster" "redis" {
  cluster_id               = "c7n-269-elasticache-redis-cluster-red"
  engine                   = "redis"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 6379
}
