resource "aws_elasticache_replication_group" "this" {
  engine                        = "redis"
  replication_group_id          = "elasticache-group-279-green"
  description                   = "279_elasticache_group_green"
  node_type                     = "cache.t2.micro"
  num_cache_clusters            = 1
  port                          = 6379
  transit_encryption_enabled    = true
  auth_token                    = random_password.this.result
  subnet_group_name             = "elasticache-subnet-279-green"
  depends_on = [aws_elasticache_subnet_group.this]
}

resource "random_password" "this" {
  length      = 18
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  special     = false
}


resource "aws_elasticache_subnet_group" "this" {
  name       = "elasticache-subnet-279-green"
  subnet_ids = [aws_subnet.this.id]
}
