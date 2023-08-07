resource "aws_elasticache_cluster" "test" {
  cluster_id        = "c7n-453-elasticache-cluster-green"
  engine            = "redis"
  node_type         = "cache.t2.micro"
  num_cache_nodes   = 1
  port              = 6379
  apply_immediately = true
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.this.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.this.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "engine-log"
  }
}
resource "aws_cloudwatch_log_group" "this" {
  name = "453-log-group-green"
}