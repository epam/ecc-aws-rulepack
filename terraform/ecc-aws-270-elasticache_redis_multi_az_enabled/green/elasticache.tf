resource "aws_elasticache_replication_group" "this" {
  engine                        = "redis"
  replication_group_id          = "c7n-270-elasticache-group-green"
  description                   = "270_elasticache_group_green"
  node_type                     = "cache.t2.micro"
  num_cache_clusters            = 2
  port                          = 6379
  subnet_group_name             = "c7n-270-elasticache-subnet-green"
  multi_az_enabled              = true
  automatic_failover_enabled    = true
  depends_on = [aws_elasticache_subnet_group.this]
}
