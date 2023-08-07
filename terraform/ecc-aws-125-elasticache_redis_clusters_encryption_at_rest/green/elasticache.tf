resource "aws_elasticache_cluster" "this" {
  cluster_id           = "elasticache-cluster-125-green"
  replication_group_id = aws_elasticache_replication_group.this.id
}

resource "aws_elasticache_replication_group" "this" {
  engine               = "redis"
  replication_group_id = "elasticache-group-125-green"
  description          = "125_elasticache_group_green"
  node_type            = "cache.t2.micro"
  num_cache_clusters   = 1
  port                 = 6379

  at_rest_encryption_enabled = true
}
