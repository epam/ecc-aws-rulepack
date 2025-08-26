# takes about 8 minutes to deploy

resource "aws_elasticache_replication_group" "redis-replication-group" {
  engine               = "redis"
  replication_group_id = "elasticache-group-redis-125-green"
  description          = "elasticache-group-125-green"
  node_type            = "cache.t2.micro"
  cluster_mode         = "enabled"
  automatic_failover_enabled = true
  num_node_groups         = 1
  replicas_per_node_group = 1
  at_rest_encryption_enabled = true
  kms_key_id          = aws_kms_key.this.arn
}

resource "aws_elasticache_replication_group" "valkey-replication-group" {
  engine               = "valkey"
  replication_group_id = "elasticache-group-valkey-125-green"
  description          = "elasticache-group-125-green"
  node_type            = "cache.t2.micro"
  cluster_mode         = "enabled"
  automatic_failover_enabled = true
  num_node_groups         = 1
  replicas_per_node_group = 1
  at_rest_encryption_enabled = true
}

