resource "aws_elasticache_cluster" "this" {
  cluster_id           = "c7n-415-elasticache-cluster-red"
  replication_group_id = aws_elasticache_replication_group.this.id
}

resource "aws_elasticache_replication_group" "this" {
  engine                        = "redis"
  replication_group_id          = "c7n-415-elasticache-group-red"
  description                   = "415_elasticache_group_red"
  node_type                     = "cache.t2.micro"
  num_cache_clusters            = 1
  port                          = 6379
}
