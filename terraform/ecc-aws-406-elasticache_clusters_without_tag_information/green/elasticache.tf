resource "aws_elasticache_cluster" "this" {
  cluster_id           = "c7n-406-elasticache-cluster-green"
  replication_group_id = aws_elasticache_replication_group.this.id
}

resource "aws_elasticache_replication_group" "this" {
  engine                        = "redis"
  replication_group_id          = "c7n-406-elasticache-group-green"
  description                   = "406_elasticache_group_green"
  node_type                     = "cache.t2.micro"
  num_cache_clusters            = 1
  port                          = 6379
}
