resource "aws_elasticache_cluster" "this" {
  cluster_id           = "c7n-267-elasticache-cluster-green"
  replication_group_id = aws_elasticache_replication_group.this.id
}

resource "aws_elasticache_replication_group" "this" {
  engine                        = "redis"
  replication_group_id          = "c7n-267-elasticache-group-green"
  description                   = "267_elasticache_group_green"
  node_type                     = "cache.t2.micro"
  num_cache_clusters            = 1
  port                          = 6379

  transit_encryption_enabled    = true
}
