resource "aws_elasticache_replication_group" "this" {
  engine                        = "redis"
  replication_group_id          = "c7n-271-elasticache-group-green"
  description                   = "271_elasticache_group_green"
  node_type                     = "cache.t2.micro"
  num_cache_clusters            = 1
  port                          = 6379
  transit_encryption_enabled    = true
  auth_token                    = random_password.this.result
  subnet_group_name             = "c7n-271-elasticache-subnet-green"

  depends_on = [aws_elasticache_subnet_group.this]
}

resource "random_password" "this" {
  length           = 18
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  special          = false
}
