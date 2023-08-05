resource "aws_elasticache_cluster" "redis" {
  cluster_id               = "c7n-272-elasticache-redis-cluster-red"
  engine                   = "redis"
  engine_version           = "5.0.6"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 6379
}

resource "aws_elasticache_cluster" "memcached" {
  cluster_id               = "c7n-272-elasticache-memcached-cluster-red"
  engine                   = "memcached"
  engine_version           = "1.5.16"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 11211
}
