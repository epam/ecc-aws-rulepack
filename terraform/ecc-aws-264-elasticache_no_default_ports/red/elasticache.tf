# it takes 4 minutes to create a cluster and 6 minutes to delete it

resource "aws_elasticache_cluster" "memcached" {
  cluster_id               = "elasticache-memcached-cluster-264-red"
  engine                   = "memcached"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 11211
}