resource "aws_elasticache_cluster" "this" {
  engine                        = "redis"
  cluster_id                    = "c7n-453-elasticache-cluster-red"
  node_type                     = "cache.t2.micro"
  num_cache_nodes               = 1
  port                          = 6379
}
