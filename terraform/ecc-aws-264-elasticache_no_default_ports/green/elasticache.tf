resource "aws_elasticache_cluster" "redis" {
  cluster_id               = "c7n-264-elasticache-redis-cluster-green"
  engine                   = "redis"
  engine_version           = "5.0.6"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 6666
}
