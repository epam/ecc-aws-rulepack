resource "aws_elasticache_cluster" "this" {
  cluster_id               = "c7n-454-elasticache-memcached-cluster-red"
  engine                   = "memcached"
  engine_version           = "1.5.16"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 11211
}
