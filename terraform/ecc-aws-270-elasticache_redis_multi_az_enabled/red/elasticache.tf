resource "aws_elasticache_replication_group" "this" {
  engine                        = "redis"
  replication_group_id          = "c7n-270-elasticache-group-red"
  description                   = "270_elasticache_group_red"
  node_type                     = "cache.t2.micro"
  num_cache_clusters            = 1
  port                          = 6379
}
