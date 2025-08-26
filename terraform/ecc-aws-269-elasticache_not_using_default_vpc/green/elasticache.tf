resource "aws_elasticache_subnet_group" "this" {
  name       = "elasticache-subnet-269-green"
  subnet_ids = [aws_subnet.this1.id, aws_subnet.this2.id]
}
resource "aws_elasticache_cluster" "memcached" {
  cluster_id               = "elasticache-memcached-cluster-264-green"
  engine                   = "memcached"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 2
  subnet_group_name        = aws_elasticache_subnet_group.this.name
}

resource "aws_elasticache_cluster" "redis-cluster" {
  cluster_id               = "elasticache-redis-cluster-269-green"
  engine                   = "redis"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 6379
  subnet_group_name        = aws_elasticache_subnet_group.this.name
}

resource "aws_elasticache_replication_group" "redis-replication-group" {
  engine               = "redis"
  replication_group_id = "elasticache-group-redis-269-green-2"
  description          = "elasticache-group-269-green"
  node_type            = "cache.t2.micro"
  cluster_mode         = "enabled"
  automatic_failover_enabled = true
  num_node_groups         = 1
  replicas_per_node_group = 1
  subnet_group_name        = aws_elasticache_subnet_group.this.name
}

resource "aws_elasticache_replication_group" "valkey-replication-group" {
  engine               = "valkey"
  replication_group_id = "elasticache-group-valkey-269-green"
  description          = "elasticache-group-269-green"
  node_type            = "cache.t2.micro"
  cluster_mode         = "enabled"
  automatic_failover_enabled = true
  num_node_groups         = 1
  replicas_per_node_group = 1
  subnet_group_name        = aws_elasticache_subnet_group.this.name
}
