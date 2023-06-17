resource "aws_elasticache_cluster" "redis" {
  cluster_id               = "c7n-420-elasticache-redis-cluster-green"
  engine                   = "redis"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 6379
}

resource "aws_elasticache_cluster" "memcached" {
  cluster_id               = "c7n-420-elasticache-memcached-cluster-green"
  engine                   = "memcached"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 11211
}
