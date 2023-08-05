resource "aws_elasticache_cluster" "memcached" {
  cluster_id               = "c7n-265-elasticache-memcached-cluster-green"
  engine                   = "memcached"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 11211
}
