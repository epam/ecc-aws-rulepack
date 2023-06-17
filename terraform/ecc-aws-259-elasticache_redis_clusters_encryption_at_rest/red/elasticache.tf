resource "aws_elasticache_cluster" "this" {
  cluster_id           = "elasticache-cluster-259-red"
  replication_group_id = aws_elasticache_replication_group.this.id
}

resource "aws_elasticache_replication_group" "this" {
  engine                     = "redis"
  replication_group_id       = "elasticache-group-259-red"
  description                = "259_elasticache_group_red"
  node_type                  = "cache.t2.micro"
  num_cache_clusters         = 1
  port                       = 6379
  at_rest_encryption_enabled = false
}
