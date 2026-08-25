# takes about 10 min to deploy

resource "aws_elasticache_replication_group" "this" {
  at_rest_encryption_enabled = true
  kms_key_id                 = data.terraform_remote_state.common.outputs.kms_key_arn
  engine                     = "redis"
  replication_group_id       = module.naming.resource_prefix.elasticache
  description                = module.naming.resource_prefix.elasticache
  node_type                  = "cache.t3.micro"
  num_cache_clusters         = 2
  port                       = 6379
  subnet_group_name          = "${module.naming.resource_prefix.elasticache}-subnetgroup"
  multi_az_enabled           = true
  automatic_failover_enabled = true
  depends_on                 = [aws_elasticache_subnet_group.this]
}

resource "aws_elasticache_subnet_group" "this" {
  name = "${module.naming.resource_prefix.elasticache}-subnetgroup"

  subnet_ids = [
    data.terraform_remote_state.common.outputs.vpc_subnet_1_id,
    data.terraform_remote_state.common.outputs.vpc_subnet_2_id
  ]
}