resource "aws_elasticache_replication_group" "this" {
  engine                        = "redis"
  replication_group_id          = "c7n-268-elasticache-group-green"
  description                   = "268_elasticache_group_green"
  node_type                     = "cache.t2.micro"
  num_cache_clusters            = 1
  port                          = 6379
  at_rest_encryption_enabled    = true
  kms_key_id                    = aws_kms_key.this.arn 
}

resource "aws_kms_key" "this" {
  description             = "268_kms_key_green"
  deletion_window_in_days = 7
}

