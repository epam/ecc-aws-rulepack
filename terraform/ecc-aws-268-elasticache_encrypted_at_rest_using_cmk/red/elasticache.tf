resource "aws_elasticache_replication_group" "this" {
  engine                        = "redis"
  replication_group_id          = "c7n-268-elasticache-group-red"
  description                   = "268_elasticache_group_red"
  node_type                     = "cache.t2.micro"
  num_cache_clusters            = 1
  port                          = 6379
}